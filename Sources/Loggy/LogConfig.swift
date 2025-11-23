//
//  LogConfig.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation

// MARK: - Log Configuration

public struct LogConfig {
    /// Enables/disables ANSI colorization in console output
    ///
    /// Note: Xcode console doesn't support ANSI colors by default,
    /// colors will work when running in Terminal or external console apps.
    ///
    /// Automatically detects if running in a terminal that supports ANSI colors.
    static let isColorizationEnabled: Bool = {
        #if canImport(Glibc)
            // Check if stderr is connected to a terminal (TTY)
            // This will be true when running in Terminal, false when running in Xcode
            return Glibc.isatty(STDOUT_FILENO) != 0
        #else
            return false
        #endif
    }()
}
