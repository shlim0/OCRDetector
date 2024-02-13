//
//  Results<Photo>+Extension.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/13/24.
//

import RealmSwift

extension Results where Element == Entity.Photo {
    func toEntity() -> Entity.Photo? {
        return first.map { return Entity.Photo(id: $0.id, date: $0.date, image: $0.image) }
    }
    
    func toEntities() -> [Entity.Photo] {
        return compactMap { return Entity.Photo(id: $0.id, date: $0.date, image: $0.image) }
    }
}
