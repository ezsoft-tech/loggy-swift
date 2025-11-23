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

private struct User {
    let id: Int
    let name: String
    let role: String
}

private func runMockScenario() {
    let users = [
        User(id: 101, name: "Alice", role: "Engineer"),
        User(id: 102, name: "Bob", role: "Designer"),
        User(id: 103, name: "Charlie", role: "PM")
    ]
    
    Loggy.v("Starting mock sync at \(Date())")
    Loggy.d("Fetched \(users.count) users from mock service", width: .large)
    
    for user in users {
        Loggy.i("User \(user.id): \(user.name) (\(user.role))")
    }
    
    Loggy.w("Pagination token missing, will refetch the first page")
    Loggy.e("Failed to persist user \(users[2].name)", width: .small)
    Loggy.wtf("Simulated fatal corruption in cache index")
    
    // Demonstrate sugar API as well
    Log.d("Shortcut log for \(users[0].name)")
    
    Loggy.d("Debug message from Loggy")
}

print("=== Loggy Example ===")
print("Running mock scenario…")
runMockScenario()
print("\nInspect the console above for table-style output.")
