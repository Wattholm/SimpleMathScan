//
//  UIButton+CornerRadius.swift
//  SimpleMathScan
//
//  Created by Kevin Joseph Mangulabnan on 5/28/22.
//

import UIKit

extension UIButton {
    @objc dynamic var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set (newValue) { layer.cornerRadius = newValue }
    }
}
