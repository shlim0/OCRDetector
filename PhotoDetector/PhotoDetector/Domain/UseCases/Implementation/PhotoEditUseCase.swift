//
//  PhotoEditUseCase.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/13/24.
//

import UIKit

final class PhotoEditUseCase: PhotoEditUseCaseProtocol {
    // MARK: - Dependencies
    private let photoReposiroty: PhotoRepository = DefaultPhotoRepository()
    
    // MARK: - Delegate
    weak var photoPreviewViewModelDelegate: PhotoPreviewViewModelProtocol?
                
    // MARK: - Public Methods
    func fetch(index: String) throws -> Entity.Photo? {
        let photo = try photoReposiroty.fetch(index: index)
        return photo
    }
    
    func fetchLast() throws -> Entity.Photo? {
        let photo = try photoReposiroty.fetchLast()
        return photo
    }
    
    func fetchAll() throws {
        let photos = try photoReposiroty.fetchAll()
        photoPreviewViewModelDelegate?.photos = photos
    }
        
    func update(index: String, direction: Bool = false) throws {
        guard !direction else { return }
        guard let photo = try photoReposiroty.fetch(index: index) else { return }
        
        let imageData = photo.image
        let image = UIImage(data: imageData)
        let imageView = UIImageView(image: image)
        
        imageView.transform = CGAffineTransform(rotationAngle: .pi * 0.5)
        
        guard let newImageData = imageView.image?.pngData() else { return }
        
        let newPhoto = Entity.Photo(id: photo.id, date: photo.date, image: newImageData)
        
        try photoReposiroty.update(photo: newPhoto)
    }
    
    func update(index: String, repoint: Bool = false) throws {
        guard !repoint else { return }
        guard let photo = try photoReposiroty.fetch(index: index) else { return }
        
        let imageData = photo.image
        let image = UIImage(data: imageData)
        let imageView = UIImageView(image: image)
        
        // TODO: repoint logic 구현 필요
        // TODO: 보일러 플레이트 줄여야 함
        
        guard let newImageData = imageView.image?.pngData() else { return }
        
        let newPhoto = Entity.Photo(id: photo.id, date: photo.date, image: newImageData)
        
        try photoReposiroty.update(photo: newPhoto)
    }
    
    func delete(index: String) throws {
        try photoReposiroty.delete(index: index)
    }
}
