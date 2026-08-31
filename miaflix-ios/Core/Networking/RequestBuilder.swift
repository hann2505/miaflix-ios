//
//  RequestBuilder.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation

public protocol RequestBuilderProtocol: Sendable {
    func build(from endpoint: Endpoint) throws -> URLRequest
}

public struct RequestBuilder: RequestBuilderProtocol {
    private let defaultHeaders: HTTPHeaders
    private let defaultTimeout: TimeInterval
    private let jsonEncoder: JSONEncoder

    public init(
        defaultHeaders: HTTPHeaders = .default,
        defaultTimeout: TimeInterval = 30.0,
        jsonEncoder: JSONEncoder = RequestBuilder.defaultJSONEncoder()
    ) {
        self.defaultHeaders = defaultHeaders
        self.defaultTimeout = defaultTimeout
        self.jsonEncoder = jsonEncoder
    }

    public static func defaultJSONEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    public func build(from endpoint: Endpoint) throws -> URLRequest {
        // Construct full URL using URLComponents
        guard var components = URLComponents(url: endpoint.baseURL, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL(endpoint.baseURL.absoluteString)
        }

        // Handle path resolution
        let basePath = components.path.hasSuffix("/") ? String(components.path.dropLast()) : components.path
        let endpointPath = endpoint.path.hasPrefix("/") ? endpoint.path : (endpoint.path.isEmpty ? "" : "/\(endpoint.path)")
        components.path = basePath + endpointPath

        // Handle query items (merge existing components.queryItems with endpoint.queryItems)
        if let newQueryItems = endpoint.queryItems, !newQueryItems.isEmpty {
            var existingItems = components.queryItems ?? []
            existingItems.append(contentsOf: newQueryItems)
            components.queryItems = existingItems
        }

        guard let finalURL = components.url else {
            throw NetworkError.invalidURL("\(endpoint.baseURL.absoluteString)/\(endpoint.path)")
        }

        // Initialize URLRequest
        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        request.timeoutInterval = endpoint.timeoutInterval ?? defaultTimeout
        if let cachePolicy = endpoint.cachePolicy {
            request.cachePolicy = cachePolicy
        }

        // Apply default headers first, then endpoint headers to allow overrides
        let allHeaders = defaultHeaders.merging(endpoint.headers ?? HTTPHeaders())
        for (headerField, headerValue) in allHeaders.dictionary {
            request.setValue(headerValue, forHTTPHeaderField: headerField)
        }

        // Handle body payload
        if let rawBody = endpoint.rawBody {
            request.httpBody = rawBody
        } else if let encodableBody = endpoint.body {
            do {
                let encodedData = try jsonEncoder.encode(AnyEncodable(encodableBody))
                request.httpBody = encodedData
                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                throw NetworkError.encodingError(error.localizedDescription)
            }
        }

        return request
    }
}

// MARK: - Type-erased Encodable Wrapper

private struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    init(_ encodable: any Encodable) {
        self.encodeClosure = { encoder in
            try encodable.encode(to: encoder)
        }
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
