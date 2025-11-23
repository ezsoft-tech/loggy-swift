//
//  LogEngine.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation

// MARK: - Internal Engine (`LogEngine`)

/// Internal helper that does the heavy lifting for all log statements.
enum LogEngine {
    
    static func log(
        _ message: Any,
        format: LogFormat,
        level: LogLevel,
        width: TableWidth,
        file: String,
        function: String,
        line: Int
    ) {
        #if DEBUG
        let className = extractClassName(from: file)
        let timestamp = currentTimestamp()
        let body = formatMessage(message, format: format)
        
        let formattedTable = LogTable.render(
            message: body,
            format: format,
            level: level,
            className: className,
            function: function,
            line: line,
            timestamp: timestamp,
            width: width
        )
        
        print(formattedTable)
        #endif
    }
    
    private static func extractClassName(from file: String) -> String {
        let filename = (file as NSString).lastPathComponent
        return (filename as NSString).deletingPathExtension
    }
    
    private static func formatMessage(_ message: Any, format: LogFormat) -> String {
        switch format {
            case .plain:
                return String(describing: message)
            case .codable:
                if let string = message as? String {
                    return prettyDescription(string)
                }
                if let pretty = prettyEncode(message) {
                    return pretty
                }
                return prettyDescription(String(describing: message))
        }
    }
    
    private static func prettyEncode(_ value: Any) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(AnyEncodable(value))
            return String(decoding: data, as: UTF8.self)
        } catch {
            return nil
        }
    }

    /// Attempts to add line breaks and two-space indentation to Swift-style descriptions.
    private static func prettyDescription(_ text: String) -> String {
        var result = ""
        var indent = 0
        let characters = Array(text)
        var index = 0
        func indentation() -> String { String(repeating: "  ", count: max(indent, 0)) }
        
        while index < characters.count {
            let ch = characters[index]
            switch ch {
                case "[", "(":
                    result.append(ch)
                    indent += 1
                    result.append("\n")
                    result.append(indentation())
                case ",":
                    result.append(",")
                    if index + 1 < characters.count && characters[index + 1] == " " {
                        index += 1
                    }
                    result.append("\n")
                    result.append(indentation())
                case "]", ")":
                    indent = max(0, indent - 1)
                    result.append("\n")
                    result.append(indentation())
                    result.append(ch)
                default:
                    result.append(ch)
            }
            index += 1
        }
        return result
    }

    private static func currentTimestamp(timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = timeZone
        return formatter.string(from: Date())
    }
}
