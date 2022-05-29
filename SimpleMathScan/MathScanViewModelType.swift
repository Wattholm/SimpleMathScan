//
//  MathScanViewModelType.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/29/22.
//

import Combine

struct MathScanViewModelInput {
    /// triggered when the screen appears
    let appear: AnyPublisher<Void, Never>
    /// triggered when the user taps the button to take a photo
    let takePhoto: AnyPublisher<Void, Never>
    /// triggered when the user taps the button to choose a photo
    let choosePhoto: AnyPublisher<Void, Never>
}

enum MathScanState {
    case idle
    case parsed([MathParserViewModel])
}

/*
extension MathScanState: Equatable {
    static func == (lhs: MathScanState, rhs: MathScanState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsMovies), .success(let rhsMovies)): return lhsMovies == rhsMovies
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}
*/

typealias MathScanViewModelOuput = AnyPublisher<MathScanState, Never>

protocol MathScanViewModelType {
    func transform(input: MathScanViewModelInput) -> MathScanViewModelOuput
}
