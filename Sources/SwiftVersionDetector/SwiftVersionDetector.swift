//
//  SwiftVersionDetector.swift
//
//
//  Created by Alessandro Venturini on 22/05/22.
//

import Foundation

/// Allows to detect Swift version at runtime.
///
/// Use ``detectRuntimeSwiftVersion()`` static method to detect the default runtime Swift version.
///
/// ```swift
/// let version = try SwiftVersionDetector.detectRuntimeSwiftVersion()
/// print(version.major) // Prints "5"
/// print(version.minor) // Prints "3"
/// print(version) // Prints "Swift version 5.3"
/// ```
public struct SwiftVersionDetector {
    
    private init() { }
    
    /// Detects the default runtime Swift version.
    ///
    /// - Throws: ``SwiftVersionDetector``.``Error`` if it is not able to detect Swift version.
    /// - Returns: A ``SwiftVersion`` struct representing the default runtime Swift version.
    public static func detectRuntimeSwiftVersion() throws -> SwiftVersion {
        let versionNumbers = try detectRuntimeSwiftVersionNumbers()
        return SwiftVersion(major: versionNumbers[0], minor: versionNumbers[1])
    }
    
    /// Detects the runtime Swift version numbers.
    ///
    /// Creates a process and asks Swift's CLI for the version.
    ///
    /// - Throws: ``SwiftVersionDetector``.``Error`` if it is not able to detect the version numbers
    /// - Returns: An array of two ``Int`` being major and minor version numbers.
    static internal func detectRuntimeSwiftVersionNumbers() throws -> [Int] {
#if os(macOS) || os(Linux)
        let process = Process()
        let stdout = Pipe()
        let shellPath = "/bin/sh"
        let command = "swift -version"
        
        process.environment = ProcessInfo.processInfo.environment
        process.arguments = ["-c", command]
        process.standardInput = nil
        process.standardOutput = stdout
        process.standardError = Pipe()
        
        if #available(macOS 10.13, *) {
            process.executableURL = URL(fileURLWithPath: shellPath)
            do { try process.run() }
            catch {
                throw Error(failureReason: "An error occurred while running process:\n\(process)")
            }
        } else {
            process.launchPath = shellPath
            process.launch()
        }
        process.waitUntilExit()
        
        guard process.terminationStatus == 0 else {
            throw Error(failureReason: "Running \"\(command)\" failed:\n\(process)",
                        recoverySuggestion: "Try to run \"\(command)\" in a shell and see if it fails too.")
        }
        
        let data = stdout.fileHandleForReading.readDataToEndOfFile()
        guard let rawVersionString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            throw Error(failureReason: "Failed parsing stdout to utf8 String")
        }
        
        return try extractVersionNumbers(from: rawVersionString)
#else
#error("This package relies on the Process class which is only supported by macOS and Linux platforms. Select an appropriate device.")
#endif
    }
    
    
    /// Given a string which contains a substring like *Swift version n.m* it extracts the version numbers.
    ///
    /// - Parameter string: A string from which extracting the version numbers.
    ///
    /// - Throws: ``SwiftVersionDetector``.``Error`` if:
    /// * no substring like *Swift version n.m* is found
    /// * it is not possible to safely parse the substring
    ///
    /// - Returns: An array of two ``Int`` being major and minor version numbers.
    static internal func extractVersionNumbers(from string: String) throws -> [Int] {
        
        let swiftVersionString = try extractSwiftVersionString(from: string)
        
        let words = swiftVersionString.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        guard words.count == 3 else {
            throw Error(failureReason: "Regex match found: \"\(words)\" but there should be only 3 words, it is unsafe to parse.")
        }
        
        // Splitting major and minor and assuring they are Int
        if words.last!.split(separator: ".").reduce(true, { $0 && (Int($1) != nil) }) {
            return words.last!.split(separator: ".").map { Int($0)! }
        } else {
            throw Error(failureReason: "Didn't find Integers while parsing version numbers: \(words.last!)")
        }
    }
    
    /// Given a string it searches and extract a substring like *Swift version n.m*
    ///
    /// - Throws: ``SwiftVersionDetector``.``Error`` in case there are no matching substrings
    /// - Returns: A string like *Swift version n.m*
    static internal func extractSwiftVersionString(from string: String) throws -> String {
        
        let regex = try! NSRegularExpression(pattern: "Swift\\s+version\\s+[0-9]+\\.[0-9]+")
        
        guard let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf8.count))
        else {
            throw Error(failureReason: "Could not find a string like \"Swift version n.m\" within: \(string).")
        }
        
        return String(string[Range(match.range, in: string)!])
    }
}
