//
//  MathParser.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/22/22.
//

import Foundation

protocol MathParseCapable {
    static func parseArithmetic(fromText text: [String]) -> (expression: String, result: String)?
}

class MathParser: MathParseCapable {
    
    enum Operand {
        case plus
        case minus
        case multiply
        case divide
    }
    
    static func parseArithmetic(fromText text: [String]) -> (expression: String, result: String)? {
        // Regular expression pattern matches a number followed by an operator, followed by another number
        // Operators include: /*+- as well as other variations of the multiplication and division symbols
        let regex = NSRegularExpression("[0-9]+\\.*[0-9]*\\s*[\\*/+÷·×xX－-]\\s*[0-9]+\\.*[0-9]*")
        var validExpression: String? = nil
        
        // Finds the first valid arithmetic expression from the text input
        for line in text {
            print(line)
            validExpression = regex.firstMatchText(in: line)
            if validExpression != nil { break }
        }
        
        guard let validExpression = validExpression else {
            print("No valid arithmetic expression was found from the input text")
            return ("Not found", "N/A")
        }
        
        let allOperands = CharacterSet(charactersIn: "+-－*·×xX÷/")
        let dotSet = CharacterSet(charactersIn: ".")
        
        let parsedExpression = validExpression.replacingOccurrences(of: " ", with: "")

        guard let argument1 = parsedExpression.components(separatedBy: allOperands).first else { return nil }
        guard let argument2 = parsedExpression.components(separatedBy: allOperands).last else { return nil }
        let operandString = parsedExpression.trimmingCharacters(in: .decimalDigits.union(dotSet))
        
        print("Argument 1: \(argument1)")
        print("Argument 2: \(argument2)")
        print("Operand: \(operandString)")
        
        var operand: Operand?
        
        switch operandString {
        case "+":
            print("Operation: addition")
            operand = .plus
        case "-", "－":
            print("Operation: subtraction")
            operand = .minus
        case "*", "·", "×", "x", "X":
            print("Operation: multiplication")
            operand = .multiply
        case "÷", "/":
            print("Operation: division")
            operand = .divide
        default:
            print("Operation: unknown")
            break
        }

        guard
            let operand = operand,
            let number1 = Float(argument1),
            let number2 = Float(argument2)
        else {
            return nil
        }
        
        do {
            guard let result = try compute(number1: number1, operand: operand, number2: number2) else {
                return nil
            }
            
            print("Valid expression: \(validExpression)")
            print("Result: \(result)")
            return (validExpression, result)
        } catch {
            return (validExpression, "Unable to compute")
        }
    }
    
    static func compute(number1: Float, operand: Operand, number2: Float) throws -> String? {
        switch operand {
        case .plus:
            return String(number1 + number2)
        case .minus:
            return String(number1 - number2)
        case .multiply:
            return String(number1 * number2)
        case .divide:
            return String(number1 / number2)
        }
    }
}
