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
        _ message: String,
        level: LogLevel,
        width: TableWidth,
        file: String,
        function: String,
        line: Int
    ) {
        #if DEBUG
        let className = extractClassName(from: file)
        let timestamp = currentTimestamp()
        
        let formattedTable = LogTable.render(
            message: message,
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
    
    private static func currentTimestamp(timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = timeZone
        return formatter.string(from: Date())
    }
}
