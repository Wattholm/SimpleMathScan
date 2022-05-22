//
//  MathParser.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/22/22.
//

import Foundation

class MathParser {
    
    enum Operand {
        case plus
        case minus
        case multiply
        case divide
    }
    
    static func parseArithmetic(fromText text: [String]) -> (expression: String, result: String)? {
        // Regular expression pattern matches any number followed by an operator, followed by another number
        // Operators include: /*+- as well as other variations of the multiplication and division symbols
        let regex = NSRegularExpression("[0-9]+\\s*[\\*/+÷·×xX－-]\\s*[0-9]+")
        var validExpression: String = ""
        
        // Finds the first valid arithmetic expression from the text input
        for line in text {
            print(line)
            if regex.matches(line) {
                let range = NSRange(location: 0, length: line.utf16.count)
                let firstMatch = regex.firstMatch(in: line, options: [], range: range)

                guard let matchRange = firstMatch?.range else {
                    continue
                }

                let matchText: String = (line as NSString).substring(with: matchRange)
                print("Matching text: \(matchText)")
                validExpression = matchText
                break
            }
        }
        
        guard !validExpression.isEmpty else {
            print("No valid arithmetic expression was found from the input text")
            return nil
        }
        
        let parsedExpression = validExpression.replacingOccurrences(of: " ", with: "")
        guard let argument1 = parsedExpression.components(separatedBy: .decimalDigits.inverted).first else { return nil }
        guard let argument2 = parsedExpression.components(separatedBy: .decimalDigits.inverted).last else { return nil }
        let operandString = parsedExpression.trimmingCharacters(in: .decimalDigits)
        
        print("Argument 1: \(argument1)")
        print("Argument 2: \(argument2)")
        print("Operand: \(operandString)")
        
        var operand: Operand?
        
        switch operandString {
        case "+":
            operand = .plus
        case "-", "－":
            operand = .minus
        case "*", "·", "×", "x", "X":
            operand = .multiply
        case "÷", "/":
            operand = .divide
        default:
            break
        }

        guard
            let operand = operand,
            let number1 = Int(argument1),
            let number2 = Int(argument2)
        else {
            return nil
        }
        
        guard let result = compute(number1: number1, operand: operand, number2: number2) else {
            return nil
        }
        
        print("Valid expression: \(validExpression)")
        print("Result: \(result)")
        return (validExpression, result)
    }
    
    static func compute(number1: Int, operand: Operand, number2: Int) -> String? {
        switch operand {
        case .plus:
            return String(Double(number1) + Double(number2))
        case .minus:
            return String(Double(number1) - Double(number2))
        case .multiply:
            return String(Double(number1) * Double(number2))
        case .divide:
            return String(Float(number1) / Float(number2))
        }
    }
}
