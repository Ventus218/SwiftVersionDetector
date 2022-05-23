import XCTest
@testable import SwiftVersionDetector

final class SwiftVersionDetectorTests: XCTestCase {
    
    /// Checks that the detected Swift version is correct.
    /// - Note: As this test relies on conditional compilation it can only test one specific version (the one on which the test is being compiled).
    func testSwiftVersionDetection() throws {
        let version = try SwiftVersionDetector.detectRuntimeSwiftVersion()
        
#if swift(>=5.6)
        XCTAssertTrue(version.major > 5 || (version.major == 5 && version.minor >= 6))
#elseif swift(>=5.5)
        XCTAssertTrue(version.major == 5 && version.minor == 5)
#elseif swift(>=5.4)
        XCTAssertTrue(version.major == 5 && version.minor == 4)
#elseif swift(>=5.3)
        XCTAssertTrue(version.major == 5 && version.minor == 3)
#elseif swift(>=5.2)
        XCTAssertTrue(version.major == 5 && version.minor == 2)
#elseif swift(>=5.1)
        XCTAssertTrue(version.major == 5 && version.minor == 1)
#elseif swift(>=5.0)
        XCTAssertTrue(version.major == 5 && version.minor == 0)
#else
        XCTAssertTrue(version.major < 5)
#endif
    }
    
    func testRegexSuccess() throws {
        let string = "swift-driver version: 1.45.2 Apple Swift version 5.6 (swiftlang-5.6.0.323.62 clang-1316.0.20.8)\nTarget: x86_64-apple-macosx12.0"
        
        let match = try SwiftVersionDetector.extractSwiftVersionString(from: string)
        XCTAssertEqual(match, "Swift version 5.6")
    }
    
    func testRegexSuccess2() throws {
        let string = "Swift version 5.5.3 (swift-5.5.3-RELEASE)\nTarget: aarch64-unknown-linux-gnu"
        
        let match = try SwiftVersionDetector.extractSwiftVersionString(from: string)
        XCTAssertEqual(match, "Swift version 5.5")
    }
    
    func testRegexSuccess3() throws {
        let string = "Swift\nversion 10.11"
        
        let match = try SwiftVersionDetector.extractSwiftVersionString(from: string)
        XCTAssertEqual(match, "Swift\nversion 10.11")
    }
    
    func testRegexSuccess4() throws {
        let string = "Swift          version 5.5.3"
        
        let match = try SwiftVersionDetector.extractSwiftVersionString(from: string)
        XCTAssertEqual(match, "Swift          version 5.5")
    }
    
    func testVersionNumbersDetectionSuccess() throws {
        let string = "swift-driver version: 1.45.2 Apple Swift version 5.6 (swiftlang-5.6.0.323.62 clang-1316.0.20.8)\nTarget: x86_64-apple-macosx12.0"
        
        let versionNumbers = try SwiftVersionDetector.extractVersionNumbers(from: string)
        XCTAssertEqual(versionNumbers, [5, 6])
    }
    
    func testVersionNumbersDetectionSuccess2() throws {
        let string = "Swift version 5.5.3 (swift-5.5.3-RELEASE)\nTarget: aarch64-unknown-linux-gnu"
        
        let versionNumbers = try SwiftVersionDetector.extractVersionNumbers(from: string)
        XCTAssertEqual(versionNumbers, [5, 5])
    }
    
    func testVersionNumbersDetectionSuccess3() throws {
        let string = "Swift\nversion 10.11"
        
        let versionNumbers = try SwiftVersionDetector.extractVersionNumbers(from: string)
        XCTAssertEqual(versionNumbers, [10, 11])
    }
    
    func testVersionNumbersDetectionSuccess4() throws {
        let string = "Swift          version 5.5.3"
        
        let versionNumbers = try SwiftVersionDetector.extractVersionNumbers(from: string)
        XCTAssertEqual(versionNumbers, [5, 5])
    }
    
    func testRegexFail() throws {
        let string = "swift-driver version: 1.45.2 Apple Swift version 5..6 (swiftlang-5.6.0.323.62 clang-1316.0.20.8)\nTarget: x86_64-apple-macosx12.0"
        XCTAssertThrowsError(try SwiftVersionDetector.extractSwiftVersionString(from: string))
    }
    
    func testRegexFail2() throws {
        let string = "Swift version 5."
        XCTAssertThrowsError(try SwiftVersionDetector.extractSwiftVersionString(from: string))
    }
    
    func testVersionNumbersDetectionFail() throws {
        let string = "swift-driver version: 1.45.2 Apple Swift version 5..6 (swiftlang-5.6.0.323.62 clang-1316.0.20.8)\nTarget: x86_64-apple-macosx12.0"
        XCTAssertThrowsError(try SwiftVersionDetector.extractVersionNumbers(from: string))
    }
    
    func testVersionNumbersDetectionFail2() throws {
        let string = "Swift version 5."
        XCTAssertThrowsError(try SwiftVersionDetector.extractVersionNumbers(from: string))
    }
    
    func testSwiftVersionDescription() throws {
        let version = try SwiftVersionDetector.detectRuntimeSwiftVersion()
        
        XCTAssertTrue("\(version)".starts(with: "Swift version \(version.major).\(version.minor)"))
        XCTAssertTrue(version.description.starts(with: "Swift version \(version.major).\(version.minor)"))
    }
}
