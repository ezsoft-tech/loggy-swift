//
//  LogFormat.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

/// Controls how messages are rendered before being sent to the table formatter.
public enum LogFormat {
    /// Use `String(describing:)` (default).
    case plain
    /// Attempt to pretty-print any `Codable` payload with 2-space indentation.
    case codable
}
