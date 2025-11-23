//
//  AnyEncodable.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation

/// Type-erased wrapper to encode heterogeneous values when formatting `.codable` output.
struct AnyEncodable: Encodable {
    private let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        switch value {
            case let encodable as Encodable:
                try encodable.encode(to: encoder)

            case let array as [Any]:
                var container = encoder.unkeyedContainer()
                for element in array {
                    try container.encode(AnyEncodable(element))
                }

            case let dict as [String: Any]:
                var container = encoder.container(keyedBy: DynamicCodingKeys.self)
                for (key, element) in dict {
                    guard let codingKey = DynamicCodingKeys(stringValue: key) else { continue }
                    try container.encode(AnyEncodable(element), forKey: codingKey)
                }
                
            default:
                var container = encoder.singleValueContainer()
                try container.encode(String(describing: value))
        }
    }
}

private struct DynamicCodingKeys: CodingKey {
    var stringValue: String
    init?(stringValue: String) { self.stringValue = stringValue }
    
    var intValue: Int? { nil }
    init?(intValue: Int) { return nil }
}
