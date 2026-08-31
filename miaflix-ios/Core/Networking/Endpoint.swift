//
//  Endpoint.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation

public protocol Endpoint: Sendable {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: (any Encodable & Sendable)? { get }
    var rawBody: Data? { get }
    var timeoutInterval: TimeInterval? { get }
    var cachePolicy: URLRequest.CachePolicy? { get }
}

public extension Endpoint {
    var headers: HTTPHeaders? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: (any Encodable & Sendable)? { nil }
    var rawBody: Data? { nil }
    var timeoutInterval: TimeInterval? { nil }
    var cachePolicy: URLRequest.CachePolicy? { nil }
}

public struct AnyEndpoint: Endpoint {
    public let baseURL: URL
    public let path: String
    public let method: HTTPMethod
    public let headers: HTTPHeaders?
    public let queryItems: [URLQueryItem]?
    public let body: (any Encodable & Sendable)?
    public let rawBody: Data?
    public let timeoutInterval: TimeInterval?
    public let cachePolicy: URLRequest.CachePolicy?

    public init(
        baseURL: URL,
        path: String,
        method: HTTPMethod = .get,
        headers: HTTPHeaders? = nil,
        queryItems: [URLQueryItem]? = nil,
        body: (any Encodable & Sendable)? = nil,
        rawBody: Data? = nil,
        timeoutInterval: TimeInterval? = nil,
        cachePolicy: URLRequest.CachePolicy? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
        self.rawBody = rawBody
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }
}
