//
//  UIView+Layer.swift
//  MovieGrid
//
//  Created by Ihor Vovk on 5/12/18.
//  Copyright © 2018 Ihor Vovk. All rights reserved.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set(newCornerRadius) {
            layer.cornerRadius = newCornerRadius
        }
    }
}
