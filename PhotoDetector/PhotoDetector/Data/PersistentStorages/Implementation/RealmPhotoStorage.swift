//
//  RealmPhotoStorage.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/13/24.
//

import Foundation
import RealmSwift

final class RealmPhotoStorage: RealmPhotoStorageProtocol {
    // MARK: - Singleton
    static let shared = RealmPhotoStorage()
    
    // MARK: - Life Cycle
    private init() {}
    
    // MARK: - Public Methods
    func save(photo: Entity.Photo) throws {
        let realm = try Realm()
        
        try realm.write{
            realm.add(photo)
        }
    }
    
    func fetch(index: String) throws -> Entity.Photo? {
        let realm = try Realm()
        
        let results = realm.objects(Entity.Photo.self)
        let predicateQuery = NSPredicate(format: "id = %@", index)
        let result = results.filter(predicateQuery)
        let photo = result.toEntity()
        
        return photo
    }
    
    func fetchLast() throws -> Entity.Photo? {
        let realm = try Realm()
        
        let results = realm.objects(Entity.Photo.self)
        let photo = results.last
        
        return photo
    }
    
    func fetchAll() throws -> [Entity.Photo] {
        let realm = try Realm()
        
        let results = realm.objects(Entity.Photo.self)
        let photos = results.toEntities()
        
        return photos
    }
    
    func update(photo: Entity.Photo) throws {
        let realm = try Realm()
        
        try realm.write {
            realm.add(photo, update: .modified)
        }
    }

    func delete(index: String) throws {
        let realm = try Realm()
        
        guard let photo = try fetch(index: index) else { return }
        
        try realm.write {
            realm.delete(photo)
        }
    }
}
