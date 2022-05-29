//
//  MathScanViewModelType.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/29/22.
//

import Foundation
import UIKit.UIImage
import Combine

struct MathScanViewModelInput {
    /// triggered after an image is received from either the camera or the photo library
    let photoReceived: AnyPublisher<UIImage?, Never>
}

typealias MathScanViewModelOuput = AnyPublisher<MathScan, Never>

protocol MathScanViewModelType {
    func transform(input: MathScanViewModelInput) -> MathScanViewModelOuput
}

final class MathScanViewModel: MathScanViewModelType {
    private var cancellables: [AnyCancellable] = []
    private let mathScanner: MathScannerType

    init(mathScanner: MathScannerType) {
        self.mathScanner = mathScanner
    }

    func transform(input: MathScanViewModelInput) -> MathScanViewModelOuput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let output = input.photoReceived
            .filter({ $0 != nil })
            .flatMap({[unowned self] image in mathScanner.scanMath(from: image!)})
            .eraseToAnyPublisher()
        
        return output
    }
}

