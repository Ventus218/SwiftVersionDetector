//
//  SwiftVersionDetectorError.swift
//  
//
//  Created by Alessandro Venturini on 22/05/22.
//

import Foundation

public extension SwiftVersionDetector {
    struct Error: LocalizedError, CustomStringConvertible {
        
        public var errorDescription: String?
        public var failureReason: String?
        public var recoverySuggestion: String?
        
        public var description: String { return errorDescription ?? "" }
        
        init(errorDescription: String? = "Unable to detect Swift version.", failureReason: String? = nil, recoverySuggestion: String? = nil) {
            self.errorDescription = errorDescription
            self.failureReason = failureReason
            self.recoverySuggestion = recoverySuggestion
        }
    }
}
