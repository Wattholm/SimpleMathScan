//
//  Publisher+Extensions.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/29/22.
//

import Combine

extension Publisher {
    static func just(_ output: Output) -> AnyPublisher<Output, Failure> {
        return Just(output)
            .catch { _ in AnyPublisher<Output, Failure>.empty() }
            .eraseToAnyPublisher()
    }

    static func empty() -> AnyPublisher<Output, Failure> {
        return Empty().eraseToAnyPublisher()
    }
}
