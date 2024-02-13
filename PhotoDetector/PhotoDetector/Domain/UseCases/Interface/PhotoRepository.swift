//
//  PhotoRepository.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/13/24.
//

protocol PhotoRepository {
    func save(photo: Entity.Photo) throws
    
    func fetch(index: String) throws -> Entity.Photo?
    func fetchLast() throws -> Entity.Photo?
    func fetchAll() throws -> [Entity.Photo]
    
    func update(photo: Entity.Photo) throws
    func delete(index: String) throws
}
