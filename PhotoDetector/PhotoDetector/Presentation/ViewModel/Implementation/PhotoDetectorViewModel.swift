//
//  PhotoDetectorViewModel.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import UIKit
import AVFoundation

final class PhotoDetectorViewModel: PhotoDetectorViewModelProtocol {
    
    // MARK: - Dependencies
    private let context: CIContext = CIContext()
    private lazy var photoInputUseCase: PhotoInputUseCaseProtocol = PhotoInputUseCase(context: context)
    private lazy var photoOutputUseCase: PhotoOutputUseCaseProtocol = PhotoOutputUseCase(context: context)
    
    // MARK: - Public Properties
    var latestPhotoOutput: PhotoOutput? = nil {
        didSet {
            guard let photo = latestPhotoOutput else { return }
            photoListener?(photo)
        }
    }
    
    var latestThumbnail: UIImage? = nil {
        didSet {
            guard let latestThumbnail = latestThumbnail else { return }
            thumbnailListener?(latestThumbnail)
        }
    }
        
    // MARK: - Binding
    var photoListener: ((PhotoOutput) -> Void)?
    var thumbnailListener: ((UIImage) -> Void)?
    
    // MARK: - Life Cycle
    init() {
        photoInputUseCase.delegate = self
        photoOutputUseCase.delegate = self
    }
    
    func handleDisplay() throws {
        try photoInputUseCase.startObservingDisplay()
    }
    
    // MARK: - Public Methods
    @objc
    func didTapShutterButton() {
        guard let photo = latestPhotoOutput else { return }
        let image = photoOutputUseCase.capture(photo)
        latestThumbnail = image
    }
}
