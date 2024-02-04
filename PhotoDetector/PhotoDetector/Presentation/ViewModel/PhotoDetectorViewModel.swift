//
//  PhotoDetectorViewModel.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import UIKit

protocol PhotoDetectorViewModelProtocol {
    func movedDisplay(uiImage: UIImage, detectorBuilder: DetectorBuilderProtocol) -> CIRectangleFeature?
    func pushedShutterButton(uiImage: UIImage)
}

final class PhotoDetectorViewModel: PhotoDetectorViewModelProtocol {
    // MARK: - Dependencies
    private var latestRectangle: CGRect? = nil {
        didSet {
            rectangleListener?()
        }
    }
    private var latestThumbnail: UIImage? = nil {
        didSet {
            thumbnailListener?()
        }
    }
    private let context: CIContext
    private lazy var imageDetectorUseCase: ImageDetectorUseCaseProtocol = ImageDetectorUseCase(context: context)
    private lazy var imageProcessingUseCase: ImageProcessingUseCaseProtocol = ImageProcessingUseCase(context: context)
    
    // MARK: - Binding
    var rectangleListener: (() -> Void)?
    var thumbnailListener: (() -> Void)?
    
    // MARK: - Life Cycle
    init(context: CIContext) {
        self.context = context
    }
    
    // MARK: - Private Methods
    private func convertUIImageToCIImage(uiImage: UIImage) -> CIImage? {
        do {
            guard let ciImage = CIImage(image: uiImage, options: [CIImageOption.colorSpace: nil] ) else {
                throw ConvertingError.failedConvertingUIImageToCIImage
            }
            return ciImage
        } catch {
            print(error.localizedDescription.debugDescription)
            return nil
        }
    }
    
    // MARK: - Public Methods
    func movedDisplay(uiImage: UIImage, detectorBuilder: DetectorBuilderProtocol = DetectorBuilder()) -> CIRectangleFeature? {
        do {
            let detector = try detectorBuilder.build(context: context)
            guard let ciImage = convertUIImageToCIImage(uiImage: uiImage) else { return nil }
            let rectangle = imageDetectorUseCase.detectImage(ciImage: ciImage, detector: detector)
            
            return rectangle
        } catch {
            print(error.localizedDescription.debugDescription)
            return nil
        }
    }
    
    func pushedShutterButton(uiImage: UIImage) {
        guard let rectangle = movedDisplay(uiImage: uiImage) else { return }
        guard let ciImage = convertUIImageToCIImage(uiImage: uiImage) else { return }
        guard let cgImage = imageProcessingUseCase.processImage(ciImage: ciImage, rectangle: rectangle) else { return }
        latestThumbnail = UIImage(cgImage: cgImage)
    }
}

