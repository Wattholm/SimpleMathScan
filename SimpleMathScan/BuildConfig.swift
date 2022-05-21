//
//  BuildConfig.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/21/22.
//

import Foundation

enum Environment: String {
    case debugGreenCamera = "Debug Green Camera"
    case debugGreenRoll = "Debug Green Roll"
    case debugRedCamera = "Debug Red Camera"
    case debugRedRoll = "Debug Red Roll"
    case releaseGreenCamera = "Release Green Camera"
    case releaseGreenRoll = "Release Green Roll"
    case releaseRedCamera = "Release Red Camera"
    case releaseRedRoll = "Release Red Roll"
    case unknown
}

class BuildConfig {
    static let shared = BuildConfig()
    
    let environment: Environment
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        
        environment = Environment(rawValue: currentConfiguration) ?? .unknown
        
        guard environment != .unknown else {
            fatalError("Unknown build configuration")
        }
    }
}
