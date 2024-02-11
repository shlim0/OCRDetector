//
//  PhotoInputUseCaseProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import CoreImage
import AVFoundation

protocol PhotoInputUseCaseProtocol: AVCaptureVideoDataOutputSampleBufferDelegate {
    var delegate: PhotoDetectorViewModelProtocol? { get set }
    
    func startObservingDisplay() throws
}
