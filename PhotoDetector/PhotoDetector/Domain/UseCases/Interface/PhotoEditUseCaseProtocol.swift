//
//  PhotoEditUseCaseProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/13/24.
//

protocol PhotoEditUseCaseProtocol {
    var photoPreviewViewModelDelegate: PhotoPreviewViewModelProtocol? { get set }
    
    func fetch(index: String) throws -> Entity.Photo?
    func fetchLast() throws -> Entity.Photo?
    func fetchAll() throws
    
    func update(index: String, direction: Bool) throws
    func update(index: String, repoint: Bool) throws
    
    func delete(index: String) throws
}
