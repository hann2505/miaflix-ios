//
//  HTTPHeaders.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation

public struct HTTPHeaders: Sendable, Equatable, ExpressibleByDictionaryLiteral {
    private var storage: [String: String] = [:]

    public var dictionary: [String: String] {
        storage
    }

    public init(_ dictionary: [String: String] = [:]) {
        self.storage = dictionary
    }

    public init(dictionaryLiteral elements: (String, String)...) {
        self.storage = Dictionary(uniqueKeysWithValues: elements)
    }

    public subscript(key: String) -> String? {
        get { storage[key] }
        set { storage[key] = newValue }
    }

    public mutating func add(name: String, value: String) {
        storage[name] = value
    }

    public mutating func remove(name: String) {
        storage.removeValue(forKey: name)
    }

    public func merging(_ other: HTTPHeaders) -> HTTPHeaders {
        var merged = storage
        for (key, value) in other.storage {
            merged[key] = value
        }
        return HTTPHeaders(merged)
    }

    // MARK: - Common Pre-configured Headers

    public static var json: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    public static func contentType(_ value: String) -> HTTPHeaders {
        ["Content-Type": value]
    }

    public static func accept(_ value: String) -> HTTPHeaders {
        ["Accept": value]
    }

    public static func bearerToken(_ token: String) -> HTTPHeaders {
        ["Authorization": "Bearer \(token)"]
    }

    public static func apiKey(_ key: String, headerName: String = "X-Api-Key") -> HTTPHeaders {
        [headerName: key]
    }

    public static func custom(name: String, value: String) -> HTTPHeaders {
        [name: value]
    }

    public static var `default`: HTTPHeaders {
        [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Accept-Language": Locale.current.identifier
        ]
    }
}
