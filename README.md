# Loggy

> Structured logging for Swift — crisp table-style console output focused on the essentials.

Loggy is a lightweight logging utility for Swift that renders rich, structured log entries directly in the Xcode console. 

It focuses on readability during development by combining:

- Table-style output (level, time, file, function, line, body)
- Short-hand APIs (`Log`) plus optional instance helpers via a `Loggable` protocol
- No external dependencies and a single entry point

---

## Features

- ✅ Simple API: `Loggy.d("message")` or `Log.d("message")`
- ✅ Table-style output in Xcode console (Level / Time / File / Function / Line / Body)
- ✅ Optional instance helpers via `Loggable`
- ✅ Pretty formatting for `Codable` payloads via `format: .codable` (model-style with indentation)
- ✅ Pretty JSON output via `format: .json` (works with JSON strings or Codable values)
- ✅ No external dependencies, pure Swift

---

## Installation

### Xcode (Swift Package Manager)

1. In Xcode, go to **File > Add Packages…**
2. Enter the repository URL:

   ```text
   https://github.com/ezsoft-tech/loggy-swift.git
   ```
   
3. Select the latest version and add **Loggy** to your target.

### Editing `Package.swift` (Alternative)

Add `Loggy` to the dependencies of your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ezsoft-tech/loggy-swift.git", from: "0.3.0")
]
```

Then add `Loggy` as a dependency of your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["Loggy"]
)
```

---

## Quick Start

### 1. Basic Logging

```swift
import Loggy

class YourClass {

    func anyMethod() {
        Loggy.d("Debug message from Loggy")
        Loggy.i("Some info")
        Loggy.w("Something looks suspicious")
        Loggy.e("An error occurred")
        Loggy.wtf("Should never happen")

        // Or using sugar facade:
        Log.d("Short style debug message")
    }
}
```

Example console output (illustrative):

```text
+--------------------------------------------------------------------------------+
| Level:  DEBUG                                        Time: 2025-11-22 22:22:26 |
| Class:  YourClass                                                              |
| Method: anyMethod()                                                            |
| Line:   36                                                                     |
| ------------------------------------------------------------------------------ |
| Debug message from Loggy.                                                      |
+--------------------------------------------------------------------------------+
```

---

### 2. Instance Logging via `Loggable`

If your type conforms to `Loggable`, you automatically gain instance helpers that forward to the global API while preserving file/function context:

```swift
import Loggy

final class SignInViewModel: Loggable {
    func signIn() {
        logI("Submitting credentials…")
        // ...
        logE("Server rejected request")
    }
}
```

---

### 3. Run the Example App

Want to see the tables in action quickly? Run the bundled example target:

```bash
swift run LoggyExample
```

This prints a series of mock log entries (using both `Loggy.*` and `Log.*`) so you can verify the console layout inside your terminal or Xcode console.

---

## API Overview

### Core Entry Point: `Loggy`

```swift
Loggy.v("Verbose message")
Loggy.d("Debug message")
Loggy.i("Info message")
Loggy.w("Warning message")
Loggy.e("Error message")
Loggy.wtf("Fatal / unexpected message")

// Optional: pretty-print Codable payloads (model-style, quoted strings)
Loggy.d(someCodableModel, format: .codable)
Loggy.d("UserListViewModel -> Fetched new users: \(users)", format: .codable)

// Optional: pretty-print JSON payloads (raw JSON strings or Codable values)
Loggy.i(jsonString, format: .json)
Loggy.i("Received API response: \(jsonString)", format: .json)
```

### Sugar Facade: `Log`

If you prefer a shorter, you can use:

```swift
Log.v("Verbose message")
Log.d("Debug message")
Log.i("Info message")
Log.w("Warning message")
Log.e("Error message")
Log.wtf("Fatal / unexpected message")
```

All of these delegate to the corresponding `Loggy` methods.

### Protocol: `Loggable`

`Loggable` is an opt-in marker that unlocks the instance helpers (`logD`, `logI`, etc.). Adopting it is as easy as declaring conformance on your class or struct—no additional requirements.

### Formatting Options

- `format: .plain` (default): renders the message as-is, wrapping long lines to the configured width.
- `format: .codable`: pretty-prints `Codable` values (or interpolated strings containing them) in a Swift-like model layout with two-space indentation and quoted strings.
- `format: .json`: pretty-prints JSON strings or encodable values as canonical JSON with two-space indentation.

#### Output `.codable` format:

```swift
import Loggy

class YourClass {

    func anyMethod() {
        // Log a list with the type of Codable model `User`
        Loggy.d(users, format: .codable)
    }
}
```

Example console output (`format: .codable`):

```text
+--------------------------------------------------------------------------------+
| Level:  DEBUG                                        Time: 2025-11-23 17:28:10 |
| Class:  YourClass                                                              |
| Method: anyMethod()                                                            |
| Line:   55                                                                     |
| ------------------------------------------------------------------------------ |
| [                                                                              |
|   User(                                                                        |
|     description: "A wise and strategic leader.",                               |
|     id: 1DB6CAFD-BC51-46A3-B9C5-8EBB7395DF51,                                  |
|     name: "Alex",                                                              |
|     role: "Supervisor"                                                         |
|   ),                                                                           |
|   User(                                                                        |
|     description: "An expert in all things technical.",                         |
|     id: DBC4B19C-BF8F-4DFD-97F4-181A0B7E7D00,                                  |
|     name: "Jamie",                                                             |
|     role: "Engineer"                                                           |
|   ),                                                                           |
|   User(                                                                        |
|     description: "The visionary driving the team forward.The visionary driving |
|     the team forward.The visionary driving the team forward.The visionary      |
|     driving the team forward.The visionary driving the team forward.The        |
|     visionary driving the team forward.",                                      |
|     id: "074664CB-BB5E-42E5-843C-78A978CA0DBC",                                |
|     name: "Bob",                                                               |
|     role: "Director"                                                           |
|   )                                                                            |
| ]                                                                              |
+--------------------------------------------------------------------------------+
```

#### Output `.json` format:

```swift
import Loggy

class YourClass {

    func anyMethod() {
        // Log a JSON string with pretty format
        Loggy.i("Received API response: \(jsonString)", format: .json)
    }
}
```

Example console output (`format: .json`):

```text
+--------------------------------------------------------------------------------+
| Level:  INFO                                         Time: 2025-11-23 18:59:23 |
| Class:  main                                                                   |
| Method: runJSONExample()                                                       |
| Line:   96                                                                     |
| ------------------------------------------------------------------------------ |
| Received API response:                                                         |
| {                                                                              |
|   "data" : {                                                                   |
|     "users" : [                                                                |
|       {                                                                        |
|         "description" : "A wise and strategic leader.",                        |
|         "id" : "AA97A172-EC9D-4B9C-94E1-0740E47524A0",                         |
|         "name" : "Alex",                                                       |
|         "role" : "Supervisor"                                                  |
|       },                                                                       |
|       {                                                                        |
|         "description" : "An expert in all things technical.",                  |
|         "id" : "8D3CF9E7-B80B-4126-9F05-3F489E2296EC",                         |
|         "name" : "Jamie",                                                      |
|         "role" : "Engineer"                                                    |
|       },                                                                       |
|       {                                                                        |
|         "description" : "This is will be a very long description about Bob, to |
|         test the wrapping logic. It should definitely wrap and continue to the |
|         next line. And then some more text to really push it over the edge.    |
|         Who knows, maybe it will even wrap into a new line and a new line and  |
|         a new line!",                                                          |
|         "id" : "E3D96A07-E612-4F23-9FFC-DCB30D2835AA",                         |
|         "name" : "Bob",                                                        |
|         "role" : "Director"                                                    |
|       }                                                                        |
|     ]                                                                          |
|   },                                                                           |
|   "status" : "success"                                                         |
| }                                                                              |
+--------------------------------------------------------------------------------+
```

---

## Roadmap

Planned enhancements (subject to change):

- 📄 File output with table-style framing/borders
- 🎛 Configurable columns, alignment, and truncation options
- 🔌 Pluggable sinks (e.g. OSLog, remote endpoints)

If you are interested in these features, feel free to open an issue or contribute.

---

## Requirements

- Swift 5.9+
- Supported platforms (initial version):
    - iOS 13+
    - macOS 10.15+
    - tvOS 13+
    - watchOS 6+

If you need support for additional platforms or lower versions, please open an issue.

---

## Contributing

Contributions are welcome!

You can help by:

1. **Opening Issues**
   - Bug reports
   - Feature requests
   - Feedback on API design or usability

2. **Submitting Pull Requests**
   - Bug fixes
   - Improvements to table rendering
   - Additional examples or documentation

Please try to:

- Follow the Swift API Design Guidelines
- Add or update unit tests when appropriate
- Keep changes focused and well-documented

---

## License

Loggy is available under the MIT License.
See [LICENSE](LICENSE) for details.

Copyright (c) 2025 ezSoft Technologies Inc.
