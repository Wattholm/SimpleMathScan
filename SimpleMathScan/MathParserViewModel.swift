//
//  MathParserViewModel.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/29/22.
//

import Foundation
import UIKit.UIImage
import Combine

struct MathParserViewModel {
    let expression: String
    let result: String
    let scannedImage: AnyPublisher<UIImage?, Never>

    init(expression: String, result: String, scannedImage: AnyPublisher<UIImage?, Never>) {
        self.expression = expression
        self.result = result
        self.scannedImage = scannedImage
    }
}

/*
extension MathParserViewModel: Hashable {
    static func == (lhs: MathParserViewModel, rhs: MathParserViewModel) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
 */
