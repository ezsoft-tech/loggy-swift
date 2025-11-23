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
        level: LogLevel,
        className: String,
        function: String,
        line: Int,
        timestamp: String,
        width: TableWidth
    ) -> String {
        let tableWidth = width.value
        let colorCode = level.colorCode
        let colorOpen = colorCode.open
        let colorClose = colorCode.close
        
        let separator = String(repeating: "-", count: tableWidth)
        let topBorder = "+" + separator + "+"
        let bottomBorder = topBorder
        
        let labelWidth = 8
        let innerWidth = tableWidth - 2
        
        let levelLabel = "Level:"
        let levelValue = level.symbol
        let timeText = "Time: \(timestamp)"
        
        let availableSpace = max(
            1,
            innerWidth - labelWidth - displayWidth(of: levelValue) - displayWidth(of: timeText)
        )
        let headerLine = paddingEnd(levelLabel, width: labelWidth) + levelValue + String(repeating: " ", count: availableSpace) + timeText
        
        let classLine = paddingEnd("Class:", width: labelWidth) + className
        let methodLine = paddingEnd("Method:", width: labelWidth) + function
        let lineLine = paddingEnd("Line:", width: labelWidth) + "\(line)"
        
        let messageLines = wrapText(message, maxWidth: innerWidth)
        
        var table = ""
        table += colorOpen
        table += topBorder
        table += "\n"
        
        let headerPadded = paddingEnd(headerLine, width: innerWidth)
        let classPadded = paddingEnd(classLine, width: innerWidth)
        let methodPadded = paddingEnd(methodLine, width: innerWidth)
        let linePadded = paddingEnd(lineLine, width: innerWidth)
        let dividerLine = String(repeating: "-", count: innerWidth)
        
        table += "| \(headerPadded) |\n"
        table += "| \(classPadded) |\n"
        table += "| \(methodPadded) |\n"
        table += "| \(linePadded) |\n"
        table += "| \(dividerLine) |\n"
        
        for messageLine in messageLines {
            let content = paddingEnd(messageLine, width: innerWidth)
            table += "| \(content) |\n"
        }
        
        table += bottomBorder
        table += colorClose
        table += "\n"
        
        return table
    }
    
    private static func wrapText(_ text: String, maxWidth: Int) -> [String] {
        guard maxWidth > 0 else { return [""] }
        var lines: [String] = []
        let words = text.split(separator: " ", omittingEmptySubsequences: false).map(String.init)
        var currentLine: String = ""
        
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
                    for character in word {
                        let charString = String(character)
                        if displayWidth(of: buffer + charString) > maxWidth, !buffer.isEmpty {
                            lines.append(buffer)
                            buffer = charString
                        } else {
                            buffer += charString
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
