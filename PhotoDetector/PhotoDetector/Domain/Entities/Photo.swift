//
//  Photo.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import Foundation
import RealmSwift

extension Entity {
    final class Photo: Object {
        @Persisted(primaryKey: true) var id: String
        @Persisted var date: Date
        @Persisted var image: Data
        
        init(id: String, date: Date, image: Data) {
            super.init()
            
            self.id = id
            self.date = date
            self.image = image
        }
    }
}
