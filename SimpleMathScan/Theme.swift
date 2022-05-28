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
            return UIColor.red
        case .green:
            return UIColor.green
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .red:
            return UIColor.systemPink
        case .green:
            return UIColor.green
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
        UIButton.appearance().backgroundColor = theme.mainColor
        UITextField.appearance().backgroundColor = theme.mainColor
    }
    
}

extension UIButton {
    @objc dynamic var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set (newValue) { layer.cornerRadius = newValue }
    }
}
