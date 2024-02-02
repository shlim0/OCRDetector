//
//  ImageDetectorUseCase.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import CoreImage

final class ImageDetectorUseCase: ImageDetectorUseCaseProtocol {
    private enum Constants {
        static let aspectRatioA4: Double = 1.414
    }
    
    // MARK: - Dependencies
    private let context: CIContext
    
    // MARK: - Life Cycle
    init(context: CIContext) {
        self.context = context
    }
    
    func detectImage(ciImage: CIImage, detector: Detectable) -> CIRectangleFeature? {
        let options = [CIDetectorAspectRatio: NSNumber(value: Constants.aspectRatioA4)]
        
        guard let rectangles = detector.features(in: ciImage, options: options) as? [CIRectangleFeature] else { return nil }
        
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        var biggestRectangle: CIRectangleFeature?
        
        // MARK: - 가장 큰 사각형 하나만을 탐색
        for rectangle in rectangles {
            let minX = min(rectangle.topLeft.x, rectangle.bottomLeft.x)
            let minY = min(rectangle.bottomLeft.y, rectangle.bottomRight.y)
            let maxX = max(rectangle.bottomRight.x, rectangle.topRight.x)
            let maxY = max(rectangle.topLeft.y, rectangle.topRight.y)
            
            if (maxX - minX > maxWidth && maxY - minY > maxHeight) {
                maxWidth = maxX - minX
                maxHeight = maxY - minY
                biggestRectangle = rectangle
            }
        }
        
        guard let rectangle = biggestRectangle else { return nil }

        return rectangle
    }
}
