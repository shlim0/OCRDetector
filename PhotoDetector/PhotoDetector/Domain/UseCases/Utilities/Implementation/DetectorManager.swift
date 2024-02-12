//
//  DetectorManager.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/8/24.
//

import CoreImage
import AVFoundation

struct DetectorManager: DetectorManagerable {
    // MARK: - Namespace
    private enum Constants {
        static let aspectRatioA4: Double = 1.414
    }

    // MARK: - Private Properties
    private let photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    private let videoOutput: AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
    
    // MARK: - Publics Properties
    let session: AVCaptureSession = AVCaptureSession()
    
    // MARK: - Public Methods
    func setUpCamera(delegate: PhotoInputUseCaseProtocol) throws {
        session.beginConfiguration()
        
        let device = try setDevice()
        let input = try setDeviceInput(device: device)
       
        try setVideoInput(input)
        try setPhotoOutput()
        try setVideoOutput(delegate)
        try setPreset()
        
        session.commitConfiguration()
    }
    
    func transform(_ ciImage: CIImage) -> CIImage {
        let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -ciImage.extent.height)
        let transformedCIImage = ciImage.transformed(by: transform)
        
        return transformedCIImage
    }
    
    func detect(of: CIImage, with: Detectable) throws -> CIRectangleFeature {
        let rectangles = try findRectangles(transformedCIImage: of, detector: with)
        let rectangle = try findBiggestRectangle(rectangles: rectangles)
        
        return rectangle
    }
}

// MARK: - Private Methods
extension DetectorManager {
    private func setDevice() throws -> AVCaptureDevice {
        // MARK: - 특정 카메라 타입이 있는지 확인하고, 없으면 default를 제공
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: .video, position: AVCaptureDevice.Position.back)
        if let device = discoverySession.devices.first {
            return device
        } else {
            guard let device = AVCaptureDevice.default(for: .video) else { throw CameraSettingError.invalidDevice }
            return device
        }
    }
        
    private func setDeviceInput(device: AVCaptureDevice) throws -> AVCaptureDeviceInput {
        let input = try AVCaptureDeviceInput(device: device)
        return input
    }
    
    private func setVideoInput(_ input: AVCaptureDeviceInput) throws {
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            throw CameraSettingError.InvalidInput.video
        }
    }
    
    private func setPhotoOutput() throws {
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        } else {
            throw CameraSettingError.InvalidOutput.photo
        }
    }
    
    private func setVideoOutput(_ delegate: PhotoInputUseCaseProtocol) throws {
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            // MARK: - AVCaptureVideoDataOutput의 회전 설정
                // !!!: .videoOrientation이 deprecated 되어 .videoRotationAngle를 사용하는 것이 맞으나,
                // !!!: 과제 명세 상, 혹시 모를 iOS 하위 버전에 대한 호환성을 고려하여 수정하지 않았음.
            videoOutput.connection(with: .video)?.videoOrientation = .portrait
            // MARK: - ViewController로 delegate 하지 않고, Use Case에서 처리하도록 함.
            videoOutput.setSampleBufferDelegate(delegate, queue: DispatchQueue(label: "VideoQueue"))
        } else {
            throw CameraSettingError.InvalidOutput.video
        }
    }
    
    private func setPreset() throws {
        let presets: [AVCaptureSession.Preset] = [.hd4K3840x2160, .hd1920x1080, .hd1280x720, .cif352x288]
        
        if let preset = presets.first(where: { session.canSetSessionPreset($0) }) {
            session.sessionPreset = preset
        } else {
            throw CameraSettingError.invalidPreset
        }
    }
    
    private func findRectangles(transformedCIImage: CIImage, detector: Detectable) throws -> [CIRectangleFeature] {
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh,
                    CIDetectorAspectRatio: Constants.aspectRatioA4] as [String : Any]
        guard let rectangles = detector.features(in: transformedCIImage, options: options) as? [CIRectangleFeature] else {
            throw DetectorError.failedConversionToCIRectangleFeature
        }
        
        return rectangles
    }
    
    private func findBiggestRectangle(rectangles: [CIRectangleFeature]) throws -> CIRectangleFeature {
        var maxWidth: CGFloat = 0
        var maxHeight: CGFloat = 0
        var biggestRectangle: CIRectangleFeature?
        
        for rectangle in rectangles {
            let minX = min(rectangle.topLeft.x, rectangle.bottomLeft.x)
            let maxX = max(rectangle.topRight.x, rectangle.bottomRight.x)
            let minY = min(rectangle.bottomLeft.y, rectangle.bottomRight.y)
            let maxY = max(rectangle.topLeft.y, rectangle.topRight.y)
            
            if (maxX - minX > maxWidth && maxY - minY > maxHeight) {
                maxWidth = maxX - minX
                maxHeight = maxY - minY
                biggestRectangle = rectangle
            }
        }
        
        guard let rectangle = biggestRectangle else {
            throw DetectorError.notFoundCIRectangleFeature
        }
        
        return rectangle
    }
}
