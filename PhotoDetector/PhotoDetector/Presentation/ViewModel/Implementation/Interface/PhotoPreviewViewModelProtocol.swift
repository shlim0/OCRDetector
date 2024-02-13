//
//  PhotoPreviewViewModelProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/13/24.
//

import Foundation

protocol PhotoPreviewViewModelProtocol: AnyObject {
    var photos: [Entity.Photo] { get set }
    
    // MARK: - Binding
    var photoListener: (([Entity.Photo]) -> Void)? { get set }

    func didTapTrashButton(index: String) throws
    func didTapCounterclockwiseButton(index: String) throws
}
