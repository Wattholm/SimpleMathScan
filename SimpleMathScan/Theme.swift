//
//  Theme.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/28/22.
//

import UIKit
import Foundation

enum AppTheme {
    case red, green
    
    var mainColor: UIColor {
        switch self {
        case .red:
            return UIColor(red: 127.5/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        case .green:
            return UIColor(red: 0.0/255.0, green: 127.5/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
    }
    
    var navBarStyle: UIBarStyle {
        switch self {
        case .red:
            return .default
        case .green:
            return .default
        }
    }
}

struct ThemeManager {
    static func applyTheme(theme: AppTheme) {
        UINavigationBar.appearance().barStyle = theme.navBarStyle
        UIButton.appearance().cornerRadius = 16
        UIButton.appearance().tintColor = .white
        UIButton.appearance().backgroundColor = theme.mainColor
        UITextField.appearance().textColor = .white
        UITextField.appearance().backgroundColor = theme.mainColor
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = theme.mainColor
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
