//
//  ImageDetectorUseCaseProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import CoreImage

protocol ImageDetectorUseCaseProtocol {
    func detectImage(ciImage: CIImage, detector: Detectable) -> CIRectangleFeature?
}
