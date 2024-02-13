//
//  PhotoPreviewViewModel.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import UIKit

final class PhotoPreviewViewModel: PhotoPreviewViewModelProtocol {
    // MARK: - Dependencies
    private var photoFetchUseCase: PhotoEditUseCaseProtocol = PhotoEditUseCase()
    
    // MARK: - Public Properties
    var photos: [Entity.Photo] = [] {
        didSet {
            guard !photos.isEmpty else { return }
            photoListener?(photos)
        }
    }
    
    // MARK: - Binding
    var photoListener: (([Entity.Photo]) -> Void)?
    
    // MARK: - Life Cycle
    init() {
        photoFetchUseCase.photoPreviewViewModelDelegate = self
    }
    
    // MARK: - Public Methods
    func didTapTrashButton(index: String) throws {
        try photoFetchUseCase.delete(index: index)
    }
    
    func didTapCounterclockwiseButton(index: String) throws {
        try photoFetchUseCase.update(index: index, direction: true)
    }
}

