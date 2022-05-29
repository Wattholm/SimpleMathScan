//
//  MathParserViewModel.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/29/22.
//

import Foundation
import UIKit.UIImage
import Combine

struct MathScan {
    let expression: String
    let result: String
    let scannedImage: UIImage?
    
    init(expression: String, result: String, scannedImage: UIImage?) {
        self.expression = expression
        self.result = result
        self.scannedImage = scannedImage
    }
}

protocol MathScannerType {
    func scanMath(from inputImage: UIImage) -> AnyPublisher<MathScan, Never>
}

struct MathScanner: MathScannerType {
    let textRecognizer: TextRecognizerType
    let mathParser: MathParseCapable
    
    init(textRecognizer: TextRecognizerType, mathParser: MathParseCapable) {
        self.textRecognizer = textRecognizer
        self.mathParser = mathParser
    }
    
    internal func scanMath(from inputImage: UIImage) -> AnyPublisher<MathScan, Never> {
        guard let cgImage = inputImage.cgImage else {
            return .just(MathScan(expression: "", result: "", scannedImage: nil))
        }
        
        // Instantiate TextRecognizer to scan text from the image
        textRecognizer.requestFromImage(cgImage: cgImage)
        
        guard let parsedValues = mathParser.parseArithmetic(fromText: textRecognizer.text) else {
            return .just(MathScan(expression: "Not found", result: "N/A", scannedImage: nil))
        }
        
        return .just(MathScan(expression: parsedValues.expression, result: parsedValues.result, scannedImage: inputImage))
    }
}
