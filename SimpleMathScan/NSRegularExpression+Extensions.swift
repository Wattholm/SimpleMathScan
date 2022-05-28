//
//  NSRegularExpression+Extension.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/22/22.
//

import Foundation

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }

    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    
    func firstMatchText(in text: String) -> String? {
        guard self.matches(text) else { return nil }
        
        let range = NSRange(location: 0, length: text.utf16.count)
        let firstMatch = self.firstMatch(in: text, options: [], range: range)
        
        guard let matchRange = firstMatch?.range else {
            return nil
        }
        
        let matchText: String = (text as NSString).substring(with: matchRange)
        print("Matching text: \(matchText)")
        return matchText
    }
}

