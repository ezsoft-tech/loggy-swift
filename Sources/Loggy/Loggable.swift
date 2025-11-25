//
//  Loggable.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation
import SwiftUI

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
        _ message: Any,
        format: LogFormat = .plain,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.v(message, format: format, width: width, file: file, function: function, line: line)
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
        _ message: Any,
        format: LogFormat = .plain,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.d(message, format: format, width: width, file: file, function: function, line: line)
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
        _ message: Any,
        format: LogFormat = .plain,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.i(message, format: format, width: width, file: file, function: function, line: line)
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
        _ message: Any,
        format: LogFormat = .plain,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.w(message, format: format, width: width, file: file, function: function, line: line)
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
        _ message: Any,
        format: LogFormat = .plain,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.e(message, format: format, width: width, file: file, function: function, line: line)
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
        _ message: Any,
        format: LogFormat = .plain,
        width: TableWidth = .medium,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        Log.wtf(message, format: format, width: width, file: file, function: function, line: line)
    }
}

// MARK: - SwiftUI View Extension

/// Extension providing view modifier logging for SwiftUI views conforming to `Loggable`.
///
/// When your SwiftUI view conforms to `Loggable`, you can use the `.log()` modifier to
/// automatically log view initialization with its parameters.
///
/// Example:
/// ```swift
/// struct MyView: View, Loggable {
///     let title: String
///     let count: Int
///
///     var body: some View {
///         Text("\(title): \(count)")
///             .log(.debug, "Custom message") // Logs struct name, init(), parameters, and line
///     }
/// }
/// ```
public extension View where Self: Loggable {
    
    /// Logs view initialization with automatic parameter capture.
    ///
    /// This modifier logs the view's actual type name, constructor signature with parameters,
    /// and captures the line number where the modifier is called. The message automatically
    /// includes actual parameter values passed to the initializer.
    ///
    /// - Parameters:
    ///   - level: The log severity level
    ///   - message: Optional custom message (default: auto-generated with parameter values)
    ///   - width: The table width (default: `.medium` / 120 characters)
    ///   - file: The file where the log is called (automatically captured)
    ///   - line: The line number where the log is called (automatically captured)
    ///
    /// Usage:
    /// ```swift
    /// MyPlanView(title: "Plan Number", value: "12345")
    ///     .log(.debug) // Logs: MyPlanView(title: "Plan Number", value: "12345")
    ///
    /// MyProfileView(name: "John Doe", phone: "800-123-4567")
    ///     .log(.info, "Rendering profile view") // Logs with custom message
    /// ```
    func log(
        _ level: LogLevel,
        _ message: String? = nil,
        width: TableWidth = .medium,
        file: String = #file,
        line: Int = #line
    ) -> some View {
        #if DEBUG
        // Extract actual struct name (not file name)
        let structName = LogEngine.extractTypeName(from: self)
        
        // Generate constructor signature for Method field
        let signature = LogEngine.extractConstructorSignature(from: self)
        
        // Generate message with actual parameter values if no custom message provided
        let finalMessage = message ?? LogEngine.constructMessage(from: self)
        
        // Create a modified file path with actual struct name
        let filePath = structName + ".swift"
        
        LogEngine.log(
            finalMessage,
            format: .plain,
            level: level,
            width: width,
            file: filePath,
            function: signature,
            line: line
        )
        #endif
        
        return self
    }
}
