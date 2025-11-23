//
//  LogTable.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation

// MARK: - Table Width

public enum TableWidth {
    case small
    case medium
    case large
    case custom(Int)
    
    var value: Int {
        switch self {
            case .small: return 80
            case .medium: return 120
            case .large: return 160
            case .custom(let width): return width
        }
    }
}

// MARK: - Log Table Renderer

/// Helper responsible for rendering log entries as formatted tables.
struct LogTable {
    
    static func render(
        message: String,
        format: LogFormat,
        level: LogLevel,
        className: String,
        function: String,
        line: Int,
        timestamp: String,
        width: TableWidth
    ) -> String {
        let baseInnerWidth = max(0, width.value - 2)
        let labelWidth = 8
        let levelLabel = "Level:"
        let levelValue = level.symbol
        let timeText = "Time: \(timestamp)"
        
        let messageLines: [String]
        let messageMax: Int
        switch format {
            case .plain:
                messageLines = wrapText(message, maxWidth: baseInnerWidth)
                messageMax = baseInnerWidth
            case .codable:
                let lines = splitMessageLines(message)
                messageLines = lines
                messageMax = lines.map { displayWidth(of: $0) }.max() ?? 0
        }
        
        var innerWidth = max(baseInnerWidth, messageMax)
        
        func buildHeaderLines(using inner: Int) -> (String, String, String, String) {
            let availableSpace = max(
                1,
                inner - labelWidth - displayWidth(of: levelValue) - displayWidth(of: timeText)
            )
            let headerLine = paddingEnd(levelLabel, width: labelWidth) + levelValue + String(repeating: " ", count: availableSpace) + timeText
            let classLine = paddingEnd("Class:", width: labelWidth) + className
            let methodLine = paddingEnd("Method:", width: labelWidth) + function
            let lineLine = paddingEnd("Line:", width: labelWidth) + "\(line)"
            return (headerLine, classLine, methodLine, lineLine)
        }
        
        var (headerLine, classLine, methodLine, lineLine) = buildHeaderLines(using: innerWidth)
        let headerMax = max(displayWidth(of: headerLine), displayWidth(of: classLine), displayWidth(of: methodLine), displayWidth(of: lineLine))
        innerWidth = max(innerWidth, headerMax)
        (headerLine, classLine, methodLine, lineLine) = buildHeaderLines(using: innerWidth)
        
        let tableWidth = innerWidth + 2
        let separator = String(repeating: "-", count: tableWidth)
        let topBorder = "+" + separator + "+"
        let bottomBorder = topBorder
        let dividerLine = String(repeating: "-", count: innerWidth)
        
        let colorCode = level.colorCode
        var table = ""
        table += colorCode.open
        table += topBorder
        table += "\n"
        
        table += "| \(paddingEnd(headerLine, width: innerWidth)) |\n"
        table += "| \(paddingEnd(classLine, width: innerWidth)) |\n"
        table += "| \(paddingEnd(methodLine, width: innerWidth)) |\n"
        table += "| \(paddingEnd(lineLine, width: innerWidth)) |\n"
        table += "| \(dividerLine) |\n"
        
        for messageLine in messageLines {
            let content = paddingEnd(messageLine, width: innerWidth)
            table += "| \(content) |\n"
        }
        
        table += bottomBorder
        table += colorCode.close
        table += "\n"
        
        return table
    }
    
    private static func splitMessageLines(_ text: String) -> [String] {
        let rawLines = text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        return rawLines.isEmpty ? [""] : rawLines
    }
    
    private static func wrapText(_ text: String, maxWidth: Int) -> [String] {
        guard maxWidth > 0 else { return [text] }
        var lines: [String] = []
        let words = text.split(separator: " ", omittingEmptySubsequences: false).map(String.init)
        var currentLine = ""
        for word in words {
            let candidate = currentLine.isEmpty ? word : currentLine + " " + word
            if displayWidth(of: candidate) <= maxWidth {
                currentLine = candidate
            } else {
                if !currentLine.isEmpty {
                    lines.append(currentLine)
                }
                if displayWidth(of: word) > maxWidth {
                    var buffer = ""
                    for ch in word {
                        let s = String(ch)
                        if displayWidth(of: buffer + s) > maxWidth, !buffer.isEmpty {
                            lines.append(buffer)
                            buffer = s
                        } else {
                            buffer += s
                        }
                    }
                    currentLine = buffer
                } else {
                    currentLine = word
                }
            }
        }
        
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }
        
        return lines.isEmpty ? [""] : lines
    }
    
    private static func paddingEnd(_ text: String, width: Int) -> String {
        let paddingCount = max(0, width - displayWidth(of: text))
        let padding = String(repeating: " ", count: paddingCount)
        return text + padding
    }
    
    private static func displayWidth(of text: String) -> Int {
        return text.reduce(into: 0) { partial, character in
            partial += displayWidth(of: character)
        }
    }
    
    private static func displayWidth(of character: Character) -> Int {
        let scalars = character.unicodeScalars
        if scalars.allSatisfy({ $0.properties.generalCategory == .format }) {
            return 0
        }
        
        if scalars.contains(where: { $0.properties.isEmojiPresentation || $0.properties.generalCategory == .otherSymbol }) {
            return 2
        }
        
        return 1
    }
}
