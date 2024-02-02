//
//  UIView+Extension.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import UIKit

extension UIView {
    func addsubViews(_ view: UIView...) {
        view.forEach { addSubview($0) }
    }
}
