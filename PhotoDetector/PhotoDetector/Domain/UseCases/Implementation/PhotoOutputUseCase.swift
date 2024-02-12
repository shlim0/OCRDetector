//
//  PhotoOutputUseCase.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import UIKit
import Photos
import AVFoundation

final class PhotoOutputUseCase: NSObject, PhotoOutputUseCaseProtocol {
    // MARK: - Namespace
    private enum Constants {
        static let defaultSaturation: Double = 0.0
        static let defaultContrast: Double = 10.0
    }
    
    // MARK: - Dependencies
    private let context: CIContext
    private let detectorManager: DetectorManagerable = DetectorManager()
    
    // MARK: - Delegate
    weak var delegate: PhotoDetectorViewModelProtocol?
    
    // MARK: - Life Cycle
    init(context: CIContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func capture(_ photo: PhotoOutput) -> UIImage {
        // MARK: - 물체를 감지한 사각형이 있을 경우 or 없을 경우 원본 이미지를 반환
        let cgImage = processImage(ciImage: photo.image) ??
                      context.createCGImage(photo.image, from: photo.image.extent)!
        let uiImage = UIImage(cgImage: cgImage)
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        return uiImage
    }
}

// MARK: - Private Methods
extension PhotoOutputUseCase {
    private func processImage(ciImage: CIImage) -> CGImage? {
        do {
            let detectorBuilder = DetectorBuilder()
            let detector = try detectorBuilder.build(with: context)
            let rectangle = try detectorManager.detect(of: ciImage, with: detector)
            
            guard let correctedCGImage = correctPerspective(of: ciImage, with: rectangle) else { return nil }
            guard let grayscaleCGImage = convertToGrayscale(correctedCGImage) else { return nil }
            guard let adjustContrast = adjustContrast(grayscaleCGImage) else { return nil }
            
            return adjustContrast
        } catch {
            guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
            guard let grayscaleCGImage = convertToGrayscale(cgImage) else { return nil }
            guard let adjustContrast = adjustContrast(grayscaleCGImage) else { return nil }
            
            return adjustContrast
        }
    }
    
    private func correctPerspective(of ciImage: CIImage, with rectangle: CIRectangleFeature) -> CGImage? {
        guard let perspectiveCorrectionFilter = CIFilter(name: "CIPerspectiveCorrection") else { return nil }
        
        perspectiveCorrectionFilter.setValue(ciImage, forKey: kCIInputImageKey)
        perspectiveCorrectionFilter.setValue(CIVector(cgPoint: rectangle.topLeft), forKey: "inputTopLeft")
        perspectiveCorrectionFilter.setValue(CIVector(cgPoint: rectangle.topRight), forKey: "inputTopRight")
        perspectiveCorrectionFilter.setValue(CIVector(cgPoint: rectangle.bottomLeft), forKey: "inputBottomLeft")
        perspectiveCorrectionFilter.setValue(CIVector(cgPoint: rectangle.bottomRight), forKey: "inputBottomRight")
        
        guard let correctedCIImage = perspectiveCorrectionFilter.outputImage else { return nil }
        return context.createCGImage(correctedCIImage, from: correctedCIImage.extent)
    }
    
    private func convertToGrayscale(_ cgImage: CGImage) -> CGImage? {
        guard let preProcessingFilter = CIFilter(name: "CIColorControls") else { return nil }
        
        preProcessingFilter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
        preProcessingFilter.setValue(Constants.defaultSaturation, forKey: kCIInputSaturationKey)
        
        guard let preProcessedCIImage = preProcessingFilter.outputImage else { return nil }
        return context.createCGImage(preProcessedCIImage, from: preProcessedCIImage.extent)
    }
    
    private func adjustContrast(_ cgImage: CGImage) -> CGImage? {
        guard let preProcessingFilter = CIFilter(name: "CIColorControls") else { return nil }
        
        preProcessingFilter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
        preProcessingFilter.setValue(Constants.defaultContrast, forKey: kCIInputContrastKey)
        
        guard let preProcessedCIImage = preProcessingFilter.outputImage else { return nil }
        return context.createCGImage(preProcessedCIImage, from: preProcessedCIImage.extent)
    }
}
