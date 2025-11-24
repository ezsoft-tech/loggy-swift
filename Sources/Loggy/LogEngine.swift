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
    
    /// Formats a message and renders the log table when DEBUG is enabled.
    /// - Parameters:
    ///   - message: Payload to log (String, Codable, JSON, etc.).
    ///   - format: Rendering format (`plain`, `codable`, or `json`).
    ///   - level: Log severity level.
    ///   - width: Desired table width.
    ///   - file: Caller file path.
    ///   - function: Caller function name.
    ///   - line: Caller line number.
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
    
    /// Extracts the filename (sans extension) from a file path.
    private static func extractClassName(from file: String) -> String {
        let filename = (file as NSString).lastPathComponent
        return (filename as NSString).deletingPathExtension
    }
    
    /// Formats the message body according to the selected `LogFormat`.
    private static func formatMessage(_ message: Any, format: LogFormat) -> String {
        switch format {
            case .plain:
                return String(describing: message)
            
            case .codable:
                if let string = message as? String {
                    return prettyDescription(string)
                }
            
                if let pretty = prettyModel(from: message) {
                    return pretty
                }
            
                return prettyDescription(String(describing: message))
            
            case .json:
                if let json = prettyJSON(from: message) {
                    return json
                }

                return prettyDescription(String(describing: message))
        }
    }

    /// Adds line breaks and two-space indentation to Swift-style descriptions.
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
    
    /// Encodes arbitrary values to JSON and renders them as a Swift-style model.
    private static func prettyModel(from value: Any) -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .withoutEscapingSlashes]
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(AnyEncodable(value))
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            let typeName: String? = {
                if let array = value as? [Any], let first = array.first {
                    return String(describing: Swift.type(of: first))
                }
                return String(describing: Swift.type(of: value))
            }()
            return renderModelStyle(json, typeName: typeName)
        } catch {
            return nil
        }
    }

    /// Renders JSON objects/arrays into a Swift-like model string with indentation.
    private static func renderModelStyle(_ value: Any, indentLevel: Int = 0, typeName: String? = nil) -> String {
        let indentUnit = "  "
        let indent = String(repeating: indentUnit, count: indentLevel)
        let nextIndent = indent + indentUnit
        
        switch value {
            case let array as [Any]:
                let rendered = array.map { element -> String in
                    renderModelStyle(element, indentLevel: indentLevel + 1, typeName: typeName)
                }.joined(separator: ",\n")
                return indent + "[\n" + rendered + "\n" + indent + "]"
            
            case let dict as [String: Any]:
                let sortedKeys = dict.keys.sorted()
                let rendered = sortedKeys.map { key in
                    let v = dict[key]!
                    let valueString = renderModelStyle(v, indentLevel: indentLevel + 1)
                    let valueLines = valueString.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
                    var composed: [String] = []
                    if let first = valueLines.first {
                        composed.append("\(nextIndent)\(key): \(first)")
                    }
                    if valueLines.count > 1 {
                        for extra in valueLines.dropFirst() {
                            composed.append(nextIndent + extra)
                        }
                    }
                    return composed.joined(separator: "\n")
                }.joined(separator: ",\n")
                let open = typeName.map { "\(indent)\($0)(" } ?? indent + "{"
                let close = typeName != nil ? indent + ")" : indent + "}"
                return open + "\n" + rendered + "\n" + close
            
            case let string as String:
                return "\"\(string)\""
            
            default:
                return String(describing: value)
        }
    }

    /// Pretty-prints JSON from strings or Encodable values.
    private static func prettyJSON(from value: Any) -> String? {
        if let string = value as? String,
           let pretty = prettyJSONString(string) { return pretty }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        encoder.dateEncodingStrategy = .iso8601

        if let data = try? encoder.encode(AnyEncodable(value)),
           let pretty = prettyJSONData(data) { return pretty }

        return nil
    }

    /// Pretty-prints a raw JSON string, preserving any text before the JSON starts.
    private static func prettyJSONString(_ text: String) -> String? {
        guard let idx = text.firstIndex(where: { $0 == "{" || $0 == "[" }) else { return nil }

        let prefix = text[..<idx]
        let jsonPortion = text[idx...]

        guard let data = String(jsonPortion).data(using: .utf8),
              let pretty = prettyJSONData(data) else { return nil }

        if prefix.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { return pretty }

        return prefix + "\n" + pretty
    }

    /// Pretty-prints raw JSON data if it represents a valid JSON object/array.
    private static func prettyJSONData(_ data: Data) -> String? {
        guard let obj = try? JSONSerialization.jsonObject(with: data, options: []),
            JSONSerialization.isValidJSONObject(obj),
            let prettyData = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys])
        else { return nil }

        return String(decoding: prettyData, as: UTF8.self)
    }

    /// Returns a timestamp string for the current date/time in the given time zone.
    private static func currentTimestamp(timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = timeZone
        return formatter.string(from: Date())
    }
}
