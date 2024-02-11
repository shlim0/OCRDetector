//
//  UIColor+Extension.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import UIKit

extension UIColor {
    class var mainColor: UIColor {
        UIColor(red: 66/255.0, green: 171/255.0, blue: 225/255.0, alpha: 1)
    }
    
    class var mainColorAlpha50: UIColor {
        UIColor(red: 66/255.0, green: 171/255.0, blue: 225/255.0, alpha: 0.5)
    }
    
    class var subColor: UIColor {
        UIColor(red: 79/255.0, green: 84/255.0, blue: 125/255.0, alpha: 1)
    }
    
    class var defaultNavigationBarColor: UIColor {
        UIColor.black.withAlphaComponent(0.5)
    }
}
