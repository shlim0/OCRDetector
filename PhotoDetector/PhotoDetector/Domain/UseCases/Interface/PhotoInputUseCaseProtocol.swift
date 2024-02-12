//
//  PhotoInputUseCaseProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import CoreImage
import AVFoundation

protocol PhotoInputUseCaseProtocol: AnyObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var delegate: PhotoDetectorViewModelProtocol? { get set }
    
    func startSession() throws
    func endSession()
}
