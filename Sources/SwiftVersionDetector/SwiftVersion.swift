//
//  SwiftVersion.swift
//  
//
//  Created by Alessandro Venturini on 23/05/22.
//



/// Represents a Swift version (major.minor).
public struct SwiftVersion {
    
    /// Major version number.
    public let major: Int
    
    /// Minor version number.
    public let minor: Int
}

extension SwiftVersion: CustomStringConvertible {
    public var description: String {
        return "Swift version \(major).\(minor)"
    }
}
