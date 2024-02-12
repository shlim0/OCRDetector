//
//  PhotoDetectorViewModelProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/8/24.
//

import UIKit

protocol PhotoDetectorViewModelProtocol: AnyObject {
    var latestPhotoOutput: PhotoOutput? { get set }
    var latestThumbnail: UIImage? { get set }
    
    // MARK: - Binding
    var photoListener: ((PhotoOutput) -> Void)? { get set }
    var thumbnailListener: ((UIImage) -> Void)? { get set }
    
    func handleDisplay() throws
    func didTapShutterButton()
}
