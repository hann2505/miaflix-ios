//
//  APIClient.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation

public protocol APIClientProtocol: Sendable {
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint, decoder: JSONDecoder?) async throws -> T
    func request<T: Decodable & Sendable>(_ request: URLRequest, decoder: JSONDecoder?) async throws -> T
    func requestData(_ endpoint: Endpoint) async throws -> (Data, HTTPURLResponse)
    func requestData(_ request: URLRequest) async throws -> (Data, HTTPURLResponse)
    func download(_ endpoint: Endpoint) async throws -> (URL, HTTPURLResponse)
}

public extension APIClientProtocol {
    func request<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        try await request(endpoint, decoder: nil)
    }

    func request<T: Decodable & Sendable>(_ request: URLRequest) async throws -> T {
        try await self.request(request, decoder: nil)
    }
}

public final class APIClient: APIClientProtocol, @unchecked Sendable {
    public static let shared = APIClient()

    private let session: URLSession
    private let requestBuilder: RequestBuilderProtocol
    private let defaultDecoder: JSONDecoder
    private let isLoggingEnabled: Bool

    public init(
        session: URLSession = .shared,
        requestBuilder: RequestBuilderProtocol = RequestBuilder(),
        defaultDecoder: JSONDecoder = APIClient.defaultJSONDecoder(),
        isLoggingEnabled: Bool = false
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
        self.defaultDecoder = defaultDecoder
        self.isLoggingEnabled = isLoggingEnabled
    }

    public static func defaultJSONDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    // MARK: - APIClientProtocol Implementation

    public func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        let urlRequest = try requestBuilder.build(from: endpoint)
        return try await request(urlRequest, decoder: decoder)
    }

    public func request<T: Decodable & Sendable>(
        _ request: URLRequest,
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        let (data, _) = try await requestData(request)
        let jsonDecoder = decoder ?? defaultDecoder

        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            let message = formatDecodingError(decodingError)
            throw NetworkError.decodingError(message)
        } catch {
            throw NetworkError.decodingError(error.localizedDescription)
        }
    }

    public func requestData(_ endpoint: Endpoint) async throws -> (Data, HTTPURLResponse) {
        let urlRequest = try requestBuilder.build(from: endpoint)
        return try await requestData(urlRequest)
    }

    public func requestData(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        logRequest(request)

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: request)
        } catch let urlError as URLError {
            let mappedError = NetworkError.mapURLError(urlError)
            logError(mappedError, for: request)
            throw mappedError
        } catch {
            let unknownError = NetworkError.unknown(error.localizedDescription)
            logError(unknownError, for: request)
            throw unknownError
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            let invalidResponseError = NetworkError.invalidResponse
            logError(invalidResponseError, for: request)
            throw invalidResponseError
        }

        logResponse(httpResponse, data: data, for: request)

        if let error = NetworkError.mapHTTPStatus(statusCode: httpResponse.statusCode, data: data) {
            throw error
        }

        return (data, httpResponse)
    }

    public func download(_ endpoint: Endpoint) async throws -> (URL, HTTPURLResponse) {
        let urlRequest = try requestBuilder.build(from: endpoint)
        logRequest(urlRequest)

        let localURL: URL
        let response: URLResponse

        do {
            (localURL, response) = try await session.download(for: urlRequest)
        } catch let urlError as URLError {
            let mappedError = NetworkError.mapURLError(urlError)
            logError(mappedError, for: urlRequest)
            throw mappedError
        } catch {
            let unknownError = NetworkError.unknown(error.localizedDescription)
            logError(unknownError, for: urlRequest)
            throw unknownError
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            let invalidResponseError = NetworkError.invalidResponse
            logError(invalidResponseError, for: urlRequest)
            throw invalidResponseError
        }

        if let error = NetworkError.mapHTTPStatus(statusCode: httpResponse.statusCode, data: nil) {
            throw error
        }

        return (localURL, httpResponse)
    }

    // MARK: - Private Logging & Error Helpers

    private func formatDecodingError(_ error: DecodingError) -> String {
        switch error {
        case .typeMismatch(let type, let context):
            return "Type mismatch for type '\(type)' at key '\(context.codingPath.map(\.stringValue).joined(separator: "."))': \(context.debugDescription)"
        case .valueNotFound(let type, let context):
            return "Value not found for type '\(type)' at key '\(context.codingPath.map(\.stringValue).joined(separator: "."))': \(context.debugDescription)"
        case .keyNotFound(let key, let context):
            return "Key '\(key.stringValue)' not found at path '\(context.codingPath.map(\.stringValue).joined(separator: "."))': \(context.debugDescription)"
        case .dataCorrupted(let context):
            return "Data corrupted at key '\(context.codingPath.map(\.stringValue).joined(separator: "."))': \(context.debugDescription)"
        @unknown default:
            return error.localizedDescription
        }
    }

    private func logRequest(_ request: URLRequest) {
        guard isLoggingEnabled else { return }
        let method = request.httpMethod ?? "GET"
        let url = request.url?.absoluteString ?? "Unknown URL"
        print("🌐 [APIClient] ➡️ \(method) \(url)")
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("🌐 [APIClient] Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("🌐 [APIClient] Body: \(bodyString)")
        }
    }

    private func logResponse(_ response: HTTPURLResponse, data: Data, for request: URLRequest) {
        guard isLoggingEnabled else { return }
        let url = request.url?.absoluteString ?? ""
        print("🌐 [APIClient] ⬅️ [\(response.statusCode)] \(url)")
        if let jsonString = String(data: data, encoding: .utf8), !jsonString.isEmpty {
            let truncated = jsonString.count > 1000 ? String(jsonString.prefix(1000)) + " ... (truncated)" : jsonString
            print("🌐 [APIClient] Response: \(truncated)")
        }
    }

    private func logError(_ error: NetworkError, for request: URLRequest) {
        guard isLoggingEnabled else { return }
        let url = request.url?.absoluteString ?? ""
        print("🌐 [APIClient] ❌ Error for \(url): \(error.localizedDescription)")
    }
}

// MARK: - Mock APIClient for Testing and Previews

public final class MockAPIClient: APIClientProtocol, @unchecked Sendable {
    public var mockData: Data?
    public var mockResponse: HTTPURLResponse?
    public var mockError: Error?
    public var mockDownloadURL: URL?

    public init(
        mockData: Data? = nil,
        mockResponse: HTTPURLResponse? = nil,
        mockError: Error? = nil,
        mockDownloadURL: URL? = nil
    ) {
        self.mockData = mockData
        self.mockResponse = mockResponse
        self.mockError = mockError
        self.mockDownloadURL = mockDownloadURL
    }

    public func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        if let mockError { throw mockError }
        guard let mockData else { throw NetworkError.invalidResponse }
        let jsonDecoder = decoder ?? APIClient.defaultJSONDecoder()
        return try jsonDecoder.decode(T.self, from: mockData)
    }

    public func request<T: Decodable & Sendable>(
        _ request: URLRequest,
        decoder: JSONDecoder? = nil
    ) async throws -> T {
        if let mockError { throw mockError }
        guard let mockData else { throw NetworkError.invalidResponse }
        let jsonDecoder = decoder ?? APIClient.defaultJSONDecoder()
        return try jsonDecoder.decode(T.self, from: mockData)
    }

    public func requestData(_ endpoint: Endpoint) async throws -> (Data, HTTPURLResponse) {
        if let mockError { throw mockError }
        let response = mockResponse ?? HTTPURLResponse(
            url: endpoint.baseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return (mockData ?? Data(), response)
    }

    public func requestData(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        if let mockError { throw mockError }
        let response = mockResponse ?? HTTPURLResponse(
            url: request.url ?? URL(string: "https://mock.local")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        return (mockData ?? Data(), response)
    }

    public func download(_ endpoint: Endpoint) async throws -> (URL, HTTPURLResponse) {
        if let mockError { throw mockError }
        let response = mockResponse ?? HTTPURLResponse(
            url: endpoint.baseURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        guard let downloadURL = mockDownloadURL else {
            throw NetworkError.invalidResponse
        }
        return (downloadURL, response)
    }
}
