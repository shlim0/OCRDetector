//
//  DetectorManagerProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/8/24.
//

import CoreImage
import AVFoundation

protocol DetectorManagerable: AnyObject {
    var session: AVCaptureSession { get }
    
    func setUpCamera(delegate: PhotoInputUseCaseProtocol) throws
    func transform(_ ciImage: CIImage) -> CIImage
    func detect(of: CIImage, with: Detectable) throws -> CIRectangleFeature
}

extension DetectorManagerable {
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
}
