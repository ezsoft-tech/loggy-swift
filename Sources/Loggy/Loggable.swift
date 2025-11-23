//
//  Loggable.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation

// MARK: - Loggable Protocol

/// Protocol that enables classes and structs to use the enhanced logging functionality
public protocol Loggable {
    var className: String { get }
}

extension Loggable {
    public var className: String {
        String(describing: type(of: self))
    }
}

// MARK: - Loggable Extension with Instance Methods

/// Extension providing convenient instance logging methods for types conforming to `Loggable`.
///
/// When your class or struct conforms to `Loggable`, you can use these instance methods to
/// log messages with automatic class name detection.
///
/// Example:
/// ```swift
/// class MyViewModel: Loggable {
///     func fetchData() {
///         logD("Starting data fetch")
///         // ... fetch logic
///         logI("Data fetched successfully")
///     }
/// }
/// ```
public extension Loggable {
    
    /// Logs a verbose message from within a `Loggable` type.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    func logV(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.v(message, width: width, file: file, function: function, line: line)
    }
    
    /// Logs a debug message from within a `Loggable` type.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    func logD(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.d(message, width: width, file: file, function: function, line: line)
    }
    
    /// Logs an informational message from within a `Loggable` type.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    func logI(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.i(message, width: width, file: file, function: function, line: line)
    }
    
    /// Logs a warning message from within a `Loggable` type.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    func logW(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.w(message, width: width, file: file, function: function, line: line)
    }
    
    /// Logs an error message from within a `Loggable` type.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    func logE(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.e(message, width: width, file: file, function: function, line: line)
    }
    
    /// Logs a fatal (What a Terrible Failure) message from within a `Loggable` type.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    func logWTF(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.wtf(message, width: width, file: file, function: function, line: line)
    }
}
