//
//  Loggy.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation

// MARK: - Public Entry Point

/// Public-facing entry point for the logging API.
///
/// Consumers typically call `Loggy.d("message")` (or any other level) directly.
/// For those who prefer a shorter name, `Log` offers the same methods and simply
/// forwards to this type.
public enum Loggy {
    
    /// Logs a verbose message with formatted table output.
    ///
    /// Verbose logs are used for detailed diagnostic information that is typically
    /// only needed when investigating specific issues. These logs provide the most
    /// granular level of detail.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///
    /// - Note: Only available in DEBUG builds.
    ///
    /// Example:
    /// ```swift
    /// Loggy.v("Detailed trace information")
    /// Loggy.v("Custom width message", width: .large)
    /// ```
    public static func v(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        LogEngine.log(message, level: .verbose, width: width, file: file, function: function, line: line)
    }
    
    /// Logs a debug message with formatted table output.
    ///
    /// Debug logs are used for general debugging information that helps understand
    /// the flow and state of the application during development. Use this for
    /// tracking variable values, execution paths, and general diagnostic information.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///
    /// - Note: Only available in DEBUG builds.
    ///
    /// Example:
    /// ```swift
    /// Loggy.d("User logged in successfully")
    /// Loggy.d("Response data: \(data)", width: .small)
    /// ```
    public static func d(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        LogEngine.log(message, level: .debug, width: width, file: file, function: function, line: line)
    }
    
    /// Logs an informational message with formatted table output.
    ///
    /// Info logs are used for important runtime events that represent normal
    /// application behavior. These logs should be used sparingly for significant
    /// milestones or state changes.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///
    /// - Note: Only available in DEBUG builds.
    ///
    /// Example:
    /// ```swift
    /// Loggy.i("Application started successfully")
    /// Loggy.i("Data sync completed")
    /// ```
    public static func i(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        LogEngine.log(message, level: .info, width: width, file: file, function: function, line: line)
    }
    
    /// Logs a warning message with formatted table output.
    ///
    /// Warning logs indicate potentially harmful situations or unexpected conditions
    /// that don't prevent the application from functioning but should be addressed.
    /// Use this for recoverable errors or deprecated API usage.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///
    /// - Note: Only available in DEBUG builds.
    ///
    /// Example:
    /// ```swift
    /// Loggy.w("API response took longer than expected")
    /// Loggy.w("Using deprecated method, please update")
    /// ```
    public static func w(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        LogEngine.log(message, level: .warning, width: width, file: file, function: function, line: line)
    }
    
    /// Logs an error message with formatted table output.
    ///
    /// Error logs indicate serious problems that have caused an operation to fail.
    /// Use this for exceptions, failed assertions, or critical errors that require
    /// immediate attention.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///
    /// - Note: Only available in DEBUG builds.
    ///
    /// Example:
    /// ```swift
    /// Loggy.e("Failed to parse JSON response: \(error.localizedDescription)")
    /// Loggy.e("Database connection failed")
    /// ```
    public static func e(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        LogEngine.log(message, level: .error, width: width, file: file, function: function, line: line)
    }
    
    /// Logs a fatal (What a Terrible Failure) message with formatted table output.
    ///
    /// WTF logs indicate errors that should never happen. Use this for conditions
    /// that represent severe programming errors or impossible states.
    ///
    /// - Parameters:
    ///   - message: The message to log
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - function: The function where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///
    /// - Note: Only available in DEBUG builds.
    ///
    /// Example:
    /// ```swift
    /// Loggy.wtf("This code path should never execute")
    /// Loggy.wtf("Invalid state detected: \(state)")
    /// ```
    public static func wtf(
        _ message: String,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        LogEngine.log(message, level: .wtf, width: width, file: file, function: function, line: line)
    }
}
