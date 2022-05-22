//
//  BuildConfig.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/21/22.
//

import Foundation

class BuildConfig {

    enum Environment: String {
        case debugGreenCamera = "Debug Green Camera"
        case debugGreenRoll = "Debug Green Roll"
        case debugRedCamera = "Debug Red Camera"
        case debugRedRoll = "Debug Red Roll"
        case releaseGreenCamera = "Release Green Camera"
        case releaseGreenRoll = "Release Green Roll"
        case releaseRedCamera = "Release Red Camera"
        case releaseRedRoll = "Release Red Roll"
    }

    enum AppFunction {
        case camera
        case roll
    }

    enum AppTheme {
        case red
        case green
    }

    static let shared = BuildConfig()
    
    let environment: Environment
    let appFunction: AppFunction
    let appTheme: AppTheme
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        
        guard let environment = Environment(rawValue: currentConfiguration) else {
            fatalError("Unknown build configuration")
        }
        
        self.environment = environment
        
        switch environment {
        case .debugGreenCamera, .releaseGreenCamera, .debugRedCamera, .releaseRedCamera:
            appFunction = .camera
        case .debugGreenRoll, .releaseGreenRoll, .debugRedRoll, .releaseRedRoll:
            appFunction = .roll
        }

        switch environment {
        case .debugGreenCamera, .releaseGreenCamera, .debugGreenRoll, .releaseGreenRoll:
            appTheme = .green
        case .debugRedCamera, .releaseRedCamera, .debugRedRoll, .releaseRedRoll:
            appTheme = .red
        }
    }
}
