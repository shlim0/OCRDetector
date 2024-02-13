//
//  DefaultPhotoRepository.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/13/24.
//

final class DefaultPhotoRepository: PhotoRepository {
    // MARK: - Dependencies
    private var realmPhotoFetchStorage: RealmPhotoStorageProtocol = RealmPhotoStorage.shared
    
    // MARK: - Public Methods
    func save(photo: Entity.Photo) throws {
        try realmPhotoFetchStorage.save(photo: photo)
    }
    
    func fetch(index: String) throws -> Entity.Photo? {
        let photo = try realmPhotoFetchStorage.fetch(index: index)
        return photo
    }
    
    func fetchLast() throws -> Entity.Photo? {
        let photo = try realmPhotoFetchStorage.fetchLast()
        return photo
    }
    
    func fetchAll() throws -> [Entity.Photo] {
        let photos = try realmPhotoFetchStorage.fetchAll()
        return photos
    }
    
    func update(photo: Entity.Photo) throws {
        try realmPhotoFetchStorage.update(photo: photo)
    }
    
    func delete(index: String) throws {
        try realmPhotoFetchStorage.delete(index: index)
    }
}
