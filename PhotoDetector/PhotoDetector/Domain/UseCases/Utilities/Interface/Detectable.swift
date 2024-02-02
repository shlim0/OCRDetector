//
//  Detectable.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import CoreImage

protocol Detectable {
    func features(in image: CIImage, options: [String : Any]?) -> [CIFeature]
}
