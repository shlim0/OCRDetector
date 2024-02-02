//
//  DetectorUseCaseProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import CoreImage

protocol ImageProcessingUseCaseProtocol {
    func processImage(ciImage: CIImage, rectangle: CIRectangleFeature) -> CGImage?
}
