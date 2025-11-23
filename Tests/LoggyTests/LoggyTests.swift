//
//  LoggyTests.swift
//  Loggy
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation
import Testing
@testable import Loggy

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

@Test func loggyAPIsProduceFormattedTables() {
    let filePath = "/tmp/SampleService.swift"
    let functionName = "performTask()"
    let lineNumber = 42
    
    let output = captureStandardOutput {
        Loggy.d(
            "Loggy debug message",
            width: .small,
            file: filePath,
            function: functionName,
            line: lineNumber
        )
    }
    
    assertCommonOutput(
        output,
        expectedMessage: "Loggy debug message",
        expectedLevelSymbol: LogLevel.debug.symbol,
        expectedClassName: "SampleService",
        expectedFunction: functionName,
        expectedLine: lineNumber
    )
}

@Test func logSugarAPIsProduceFormattedTables() {
    let filePath = "/tmp/SampleController.swift"
    let functionName = "handleEvent()"
    let lineNumber = 101
    
    let output = captureStandardOutput {
        Log.w(
            "Shorthand warning",
            width: .medium,
            file: filePath,
            function: functionName,
            line: lineNumber
        )
    }
    
    assertCommonOutput(
        output,
        expectedMessage: "Shorthand warning",
        expectedLevelSymbol: LogLevel.warning.symbol,
        expectedClassName: "SampleController",
        expectedFunction: functionName,
        expectedLine: lineNumber
    )
}

// MARK: - Helpers

private func assertCommonOutput(
    _ output: String,
    expectedMessage: String,
    expectedLevelSymbol: String,
    expectedClassName: String,
    expectedFunction: String,
    expectedLine: Int,
) {
    let rows = output.split(separator: "\n").map(String.init)
    
    func row(containing label: String) -> String? {
        rows.first { $0.contains(label) }
    }
    
    #expect(row(containing: expectedMessage) != nil, "Missing log message")
    #expect(row(containing: "Level:")?.contains(expectedLevelSymbol) == true, "Missing level symbol")
    #expect(row(containing: "Class:")?.contains(expectedClassName) == true, "Missing class name")
    #expect(row(containing: "Method:")?.contains(expectedFunction) == true, "Missing function name")
    #expect(row(containing: "Line:")?.contains("\(expectedLine)") == true, "Missing line indicator")
    #expect(row(containing: "Time:") != nil, "Missing timestamp")
}

private func captureStandardOutput(_ block: () -> Void) -> String {
    fflush(stdout)
    let pipe = Pipe()
    let originalStdout = dup(STDOUT_FILENO)
    dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
    
    block()
    
    fflush(stdout)
    pipe.fileHandleForWriting.closeFile()
    
    dup2(originalStdout, STDOUT_FILENO)
    close(originalStdout)
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    pipe.fileHandleForReading.closeFile()
    
    return String(data: data, encoding: .utf8) ?? ""
}
