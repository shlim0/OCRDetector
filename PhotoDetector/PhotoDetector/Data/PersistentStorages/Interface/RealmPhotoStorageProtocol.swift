//
//  RealmPhotoStorageProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/13/24.
//

import Foundation

protocol RealmPhotoStorageProtocol {
    func save(photo: Entity.Photo) throws
    
    func fetch(index: String) throws -> Entity.Photo?
    func fetchLast() throws -> Entity.Photo?
    func fetchAll() throws -> [Entity.Photo]
    
    func update(photo: Entity.Photo) throws
    func delete(index: String) throws
}
