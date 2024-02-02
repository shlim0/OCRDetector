//
//  DetectorUseCase.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import CoreImage

final class ImageProcessingUseCase: ImageProcessingUseCaseProtocol {
    // MARK: - Dependencies
    private let context: CIContext
    
    // MARK: - Life Cycle
    init(context: CIContext) {
        self.context = context
    }
    
    func processImage(ciImage: CIImage, rectangle: CIRectangleFeature) -> CGImage? {
        // MARK: - 이미지 위치 보정하여 전체화면으로 crop
        guard let perspectiveCorrectionFilter = CIFilter(name: "CIPerspectiveCorrection") else { return nil }
        
        perspectiveCorrectionFilter.setValue(ciImage, forKey: kCIInputImageKey)
        perspectiveCorrectionFilter.setValue(CIVector(cgPoint: rectangle.topLeft), forKey: "inputTopLeft")
        perspectiveCorrectionFilter.setValue(CIVector(cgPoint: rectangle.topRight), forKey: "inputTopRight")
        perspectiveCorrectionFilter.setValue(CIVector(cgPoint: rectangle.bottomLeft), forKey: "inputBottomLeft")
        perspectiveCorrectionFilter.setValue(CIVector(cgPoint: rectangle.bottomRight), forKey: "inputBottomRight")
        
        guard let correctedCIImage = perspectiveCorrectionFilter.outputImage else { return nil }
        guard let correctedCGImage = context.createCGImage(correctedCIImage, from: correctedCIImage.extent) else { return nil }
        
        // MARK: - 이미지 흑백 변환
        guard let preProcessingFilter = CIFilter(name: "CIColorControls") else { return nil }
        
        preProcessingFilter.setValue(CIImage(cgImage: correctedCGImage), forKey: kCIInputImageKey)
        preProcessingFilter.setValue(PhotoDetectorViewController.defaultSaturation, forKey: kCIInputSaturationKey)
        
        // MARK: - 이미지 대비 조절
        preProcessingFilter.setValue(PhotoDetectorViewController.defaultContrast, forKey: kCIInputContrastKey)
        
        guard let preProcessedCIImage = preProcessingFilter.outputImage else { return nil }
        guard let preProcessedCGImage = context.createCGImage(preProcessedCIImage, from: preProcessedCIImage.extent) else { return nil }
        
        return preProcessedCGImage
    }
}
