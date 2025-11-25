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
import SwiftUI
import Loggy

// Example model that conforms to Codable, used to demonstrate pretty-printing.
private struct User: Codable {
    let id: UUID
    let name: String
    let role: String
    let description: String
}

private extension User {
    static let mocks: [User] = [
        .init(id: UUID(), name: "Alex", role: "Supervisor", description: "A wise and strategic leader."),
        .init(id: UUID(), name: "Jamie", role: "Engineer", description: "An expert in all things technical."),
        .init(id: UUID(), name: "Bob", role: "Director", description: "This is will be a very long description about Bob, to test the wrapping logic. It should definitely wrap and continue to the next line. And then some more text to really push it over the edge. Who knows, maybe it will even wrap into a new line and a new line and a new line!")
    ]
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
    let users = User.mocks
    
    // Without format: .codable this would be a single long line; .codable indents with two spaces.
    Loggy.d("UserListViewModel -> Fetched new users: \(users)")
    
    Loggy.d(
        "UserListViewModel -> Fetched new users: \(users)",
        format: .codable
    )
    
    Loggy.d(users, format: .codable)
}

/// Demonstrates pretty-printing of JSON strings using `format: .json`.
private func runJSONExample() {
    print("\n--- JSON pretty-print ---")
    let users = User.mocks

    // Using .json format to pretty-print JSON strings.
    let jsonString = """
    {
        "status": "success",
        "data": {
            "users": [
                {
                    "id": "\(users[0].id)",
                    "name": "\(users[0].name)",
                    "role": "\(users[0].role)",
                    "description": "\(users[0].description)"
                },
                {
                    "id": "\(users[1].id)",
                    "name": "\(users[1].name)",
                    "role": "\(users[1].role)",
                    "description": "\(users[1].description)"
                },
                {
                    "id": "\(users[2].id)",
                    "name": "\(users[2].name)",
                    "role": "\(users[2].role)",
                    "description": "\(users[2].description)"
                }
            ]
        }
    }
    """

    Loggy.i(
        "Received API response: \(jsonString)",
        format: .json
    )

    Loggy.i(jsonString, format: .json)
}

// MARK: - SwiftUI Example

/// Simple SwiftUI view that conforms to `Loggable` so it can use the `.log` modifier.
private struct ProfileCard: View, Loggable {
    let name: String
    let title: String
    let isOnline: Bool
    let favoriteQuote: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name).font(.headline)
            Text(title).font(.subheadline)
            Text(isOnline ? "Online" : "Offline").font(.footnote)
            
            if let favoriteQuote {
                Text("“\(favoriteQuote)”")
                    .italic()
                    .font(.caption)
                    .foregroundColor(Color(.gray))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .strokeBorder(Color(.gray).opacity(0.3), lineWidth: 1)
        )
    }
}

/// Demonstrates logging SwiftUI view initialization with the `.log` modifier.
@MainActor
private func runSwiftUIExample() {
    print("\n--- SwiftUI view logging with .log ---")
    
    _ = ProfileCard(
        name: "Taylor",
        title: "iOS Engineer",
        isOnline: true,
        favoriteQuote: "Shipping beats perfection."
    )
    .log(.debug) // Logs type name, init signature, and parameter values
    
    _ = ProfileCard(
        name: "Jordan",
        title: "Product Manager",
        isOnline: false,
        favoriteQuote: nil
    )
    .log(.info, "Rendering profile card with custom message")
}

// MARK: - Entry Point

print("=== Loggy Example ===")
runBasicLevels()
runCodableExample()
runJSONExample()
runSwiftUIExample()
print("\nInspect the console above for table-style output, including the pretty-printed Codable example and SwiftUI .log modifier output.")
