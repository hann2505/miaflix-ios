//
//  NetworkingTests.swift
//  miaflix-iosTests
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Testing
import Foundation
@testable import miaflix_ios

struct NetworkingTests {

    // MARK: - HTTPMethod Tests

    @Test func testHTTPMethodRawValues() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
        #expect(HTTPMethod.put.rawValue == "PUT")
        #expect(HTTPMethod.patch.rawValue == "PATCH")
        #expect(HTTPMethod.delete.rawValue == "DELETE")
        #expect(HTTPMethod.head.rawValue == "HEAD")
        #expect(HTTPMethod.options.rawValue == "OPTIONS")
    }

    // MARK: - HTTPHeaders Tests

    @Test func testHTTPHeadersOperations() {
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        #expect(headers["Content-Type"] == "application/json")

        headers.add(name: "Authorization", value: "Bearer token123")
        #expect(headers["Authorization"] == "Bearer token123")

        let extraHeaders: HTTPHeaders = ["X-Custom": "CustomValue"]
        let merged = headers.merging(extraHeaders)
        #expect(merged["Content-Type"] == "application/json")
        #expect(merged["Authorization"] == "Bearer token123")
        #expect(merged["X-Custom"] == "CustomValue")

        headers.remove(name: "Authorization")
        #expect(headers["Authorization"] == nil)
    }

    // MARK: - NetworkError Tests

    @Test func testNetworkErrorStatusMapping() {
        #expect(NetworkError.mapHTTPStatus(statusCode: 200, data: nil) == nil)
        #expect(NetworkError.mapHTTPStatus(statusCode: 204, data: nil) == nil)
        #expect(NetworkError.mapHTTPStatus(statusCode: 401, data: nil) == .unauthorized(data: nil))
        #expect(NetworkError.mapHTTPStatus(statusCode: 403, data: nil) == .forbidden(data: nil))
        #expect(NetworkError.mapHTTPStatus(statusCode: 404, data: nil) == .notFound)
        #expect(NetworkError.mapHTTPStatus(statusCode: 500, data: nil) == .serverError(statusCode: 500, data: nil))
        #expect(NetworkError.mapHTTPStatus(statusCode: 418, data: nil) == .httpError(statusCode: 418, data: nil))
    }

    @Test func testNetworkErrorURLErrorMapping() {
        let noInternetError = URLError(.notConnectedToInternet)
        #expect(NetworkError.mapURLError(noInternetError) == .noInternet)

        let timeoutError = URLError(.timedOut)
        #expect(NetworkError.mapURLError(timeoutError) == .timeout)

        let cancelledError = URLError(.cancelled)
        #expect(NetworkError.mapURLError(cancelledError) == .cancelled)
    }

    // MARK: - RequestBuilder Tests

    struct SamplePayload: Codable, Sendable, Equatable {
        let movieTitle: String
        let releaseYear: Int
    }

    @Test func testRequestBuilderGetRequest() throws {
        let endpoint = AnyEndpoint(
            baseURL: URL(string: "https://api.miaflix.com")!,
            path: "movies/popular",
            method: .get,
            queryItems: [URLQueryItem(name: "page", value: "1")]
        )

        let builder = RequestBuilder()
        let request = try builder.build(from: endpoint)

        #expect(request.httpMethod == "GET")
        #expect(request.url?.absoluteString == "https://api.miaflix.com/movies/popular?page=1")
        #expect(request.value(forHTTPHeaderField: "Accept") == "application/json")
    }

    @Test func testRequestBuilderPostWithJSONBody() throws {
        let payload = SamplePayload(movieTitle: "Inception", releaseYear: 2010)
        let endpoint = AnyEndpoint(
            baseURL: URL(string: "https://api.miaflix.com")!,
            path: "/api/v1/movies",
            method: .post,
            headers: ["X-Api-Key": "secret123"],
            body: payload
        )

        let builder = RequestBuilder()
        let request = try builder.build(from: endpoint)

        #expect(request.httpMethod == "POST")
        #expect(request.url?.absoluteString == "https://api.miaflix.com/api/v1/movies")
        #expect(request.value(forHTTPHeaderField: "X-Api-Key") == "secret123")
        #expect(request.value(forHTTPHeaderField: "Content-Type") == "application/json")

        guard let bodyData = request.httpBody else {
            Issue.record("Expected httpBody to be present")
            return
        }

        // Verify that default JSONEncoder converted keys to snake_case (`movie_title`, `release_year`)
        let snakeDecoder = APIClient.defaultJSONDecoder()
        let snakeDecoded = try snakeDecoder.decode(SamplePayload.self, from: bodyData)
        #expect(snakeDecoded == payload)
    }

    // MARK: - MockAPIClient Tests

    struct MovieDTO: Codable, Sendable, Equatable {
        let id: Int
        let title: String
    }

    @Test func testMockAPIClientSuccess() async throws {
        let json = """
        {
            "id": 42,
            "title": "Interstellar"
        }
        """.data(using: .utf8)!

        let mockClient = MockAPIClient(mockData: json)
        let endpoint = AnyEndpoint(
            baseURL: URL(string: "https://api.miaflix.com")!,
            path: "movies/42"
        )

        let movie: MovieDTO = try await mockClient.request(endpoint)
        #expect(movie.id == 42)
        #expect(movie.title == "Interstellar")
    }

    @Test func testMockAPIClientError() async {
        let mockClient = MockAPIClient(mockError: NetworkError.notFound)
        let endpoint = AnyEndpoint(
            baseURL: URL(string: "https://api.miaflix.com")!,
            path: "movies/999"
        )

        do {
            let _: MovieDTO = try await mockClient.request(endpoint)
            Issue.record("Expected request to throw an error")
        } catch let error as NetworkError {
            #expect(error == .notFound)
        } catch {
            Issue.record("Unexpected error type: \(error)")
        }
    }
}
