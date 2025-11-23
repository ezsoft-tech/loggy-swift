//
//  main.swift
//  LoggyExample
//
//  Demonstrates Loggy's table output with mock data.
//
//  Copyright (c) 2025 ezSoft Technologies Inc.
//  Licensed under the MIT License. See LICENSE for details.
//

import Foundation
import Loggy

// Example model that conforms to Codable, used to demonstrate pretty-printing.
private struct User: Codable {
    let id: UUID
    let name: String
    let role: String
    let description: String
}

// MARK: - Example Runs

/// Shows each severity level with concise, plain-text messages.
private func runBasicLevels() {
    print("\n--- Basic severity logs ---")
    
    Loggy.v("Verbose: initializing mock sync")
    Loggy.d("Debug: fetched configuration")
    Loggy.i("Info: sync completed successfully")
    Loggy.w("Warning: pagination token missing, retrying first page")
    Loggy.e("Error: failed to persist cache entry", width: .small)
    Loggy.wtf("Fatal: unrecoverable corruption detected")
    
    Log.d("Sugar: shorthand log via Log facade")
}

/// Demonstrates pretty-printing of Codable payloads using `format: .codable`.
private func runCodableExample() {
    print("\n--- Codable pretty-print ---")
    let users: [User] = [
        .init(id: UUID(), name: "Alex", role: "Supervisor", description: "A wise and strategic leader."),
        .init(id: UUID(), name: "Jamie", role: "Engineer", description: "An expert in all things technical."),
        .init(id: UUID(), name: "Bob", role: "Director", description: "The visionary driving the team forward.The visionary driving the team forward.The visionary driving the team forward.The visionary driving the team forward.The visionary driving the team forward.The visionary driving the team forward."),
    ]
    
    // Without format: .codable this would be a single long line; .codable indents with two spaces.
    Loggy.d("UserListViewModel -> Fetched new users: \(users)")
    
    Loggy.d(
        "UserListViewModel -> Fetched new users: \(users)",
        format: .codable
    )
    
    Loggy.d(users, format: .codable)
}

// MARK: - Entry Point

print("=== Loggy Example ===")
runBasicLevels()
runCodableExample()
print("\nInspect the console above for table-style output, including the pretty-printed Codable example.")
