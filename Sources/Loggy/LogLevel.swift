//
//  LogLevel.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation

// MARK: - Log Level

public enum LogLevel {
    case verbose
    case debug
    case info
    case warning
    case error
    case wtf
    
    var symbol: String {
        switch self {
            case .verbose: return "VERBOSE"
            case .debug: return "DEBUG"
            case .info: return "INFO"
            case .warning: return "WARNING"
            case .error: return "ERROR"
            case .wtf: return "WTF"
        }
    }
    
    var colorCode: (open: String, close: String) {
        guard LogConfig.isColorizationEnabled else {
            return ("", "")
        }
        
        switch self {
            case .verbose: return ("\u{001B}[37m", "\u{001B}[0m")
            case .debug: return ("\u{001B}[32m", "\u{001B}[0m")
            case .info: return ("\u{001B}[34m", "\u{001B}[0m")
            case .warning: return ("\u{001B}[33m", "\u{001B}[0m")
            case .error: return ("\u{001B}[31m", "\u{001B}[0m")
            case .wtf: return ("\u{001B}[31m", "\u{001B}[0m")
        }
    }
}
