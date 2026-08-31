//
//  NetworkError.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation

public enum NetworkError: Error, LocalizedError, Sendable, Equatable {
    case invalidURL(String)
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case decodingError(String)
    case encodingError(String)
    case networkFailure(String)
    case unauthorized(data: Data?)
    case forbidden(data: Data?)
    case notFound
    case serverError(statusCode: Int, data: Data?)
    case noInternet
    case timeout
    case cancelled
    case unknown(String?)

    public var errorDescription: String? {
        switch self {
        case .invalidURL(let urlString):
            return "The URL '\(urlString)' is invalid."
        case .invalidResponse:
            return "Received an invalid or unexpected response from the server."
        case .httpError(let statusCode, _):
            return "HTTP request failed with status code: \(statusCode)."
        case .decodingError(let reason):
            return "Failed to decode response data: \(reason)."
        case .encodingError(let reason):
            return "Failed to encode request payload: \(reason)."
        case .networkFailure(let reason):
            return "Network connection failed: \(reason)."
        case .unauthorized:
            return "Authentication required. Please check your credentials."
        case .forbidden:
            return "You do not have permission to access this resource."
        case .notFound:
            return "The requested resource was not found on the server."
        case .serverError(let statusCode, _):
            return "Server encountered an error (HTTP \(statusCode)). Please try again later."
        case .noInternet:
            return "No internet connection available. Please check your network settings."
        case .timeout:
            return "The request timed out. Please try again."
        case .cancelled:
            return "The request was cancelled."
        case .unknown(let reason):
            return reason ?? "An unknown network error occurred."
        }
    }

    public var statusCode: Int? {
        switch self {
        case .httpError(let code, _), .serverError(let code, _):
            return code
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .notFound:
            return 404
        default:
            return nil
        }
    }

    public var responseData: Data? {
        switch self {
        case .httpError(_, let data),
             .serverError(_, let data),
             .unauthorized(let data),
             .forbidden(let data):
            return data
        default:
            return nil
        }
    }

    public func decodeErrorBody<T: Decodable>(
        as type: T.Type = T.self,
        decoder: JSONDecoder = JSONDecoder()
    ) -> T? {
        guard let data = responseData else { return nil }
        return try? decoder.decode(T.self, from: data)
    }

    public static func mapURLError(_ urlError: URLError) -> NetworkError {
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .noInternet
        case .timedOut:
            return .timeout
        case .cancelled:
            return .cancelled
        case .badURL, .unsupportedURL:
            return .invalidURL(urlError.failureURLString ?? "")
        default:
            return .networkFailure(urlError.localizedDescription)
        }
    }

    public static func mapHTTPStatus(statusCode: Int, data: Data?) -> NetworkError? {
        guard !(200...299).contains(statusCode) else { return nil }

        switch statusCode {
        case 401:
            return .unauthorized(data: data)
        case 403:
            return .forbidden(data: data)
        case 404:
            return .notFound
        case 500...599:
            return .serverError(statusCode: statusCode, data: data)
        default:
            return .httpError(statusCode: statusCode, data: data)
        }
    }
}
