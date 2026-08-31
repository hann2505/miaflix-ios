//
//  HTTPMethod.swift
//  miaflix-ios
//
//  Created by Hà Nguyễn on 31/8/26.
//

import Foundation

public enum HTTPMethod: String, Sendable, Equatable, Hashable, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
}
