//
//  PhotoInputUseCase.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/2/24.
//

import UIKit
import AVFoundation

final class PhotoInputUseCase: NSObject, PhotoInputUseCaseProtocol {
    // MARK: - Namespace
    private enum Constants {
        static let defaultXAxisCorrection: Double = 20
        static let defaultYAxisCorrection: Double = 25
    }
    
    // MARK: - Dependencies
    private let context: CIContext
    private let detectorManager: DetectorManagerable = DetectorManager()
    
    // MARK: - Flag Property
    private var isDrawing = false
    
    // MARK: - Delegate
    weak var delegate: PhotoDetectorViewModelProtocol?
    
    // MARK: - Life Cycle
    init(context: CIContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func startSession() throws {
        Task {
            guard await detectorManager.isAuthorized else { return }
        }
        
        try detectorManager.setUpCamera(delegate: self)
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            detectorManager.session.startRunning()
        }
    }
    
    func endSession() {
        detectorManager.session.stopRunning()
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension PhotoInputUseCase {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer), !isDrawing else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        Task {
            isDrawing = true
                        
            do {
                let rectangle = try detectRectangle(ciImage: ciImage)
                let photoOutput = try await drawPreviewLayer(using: ciImage, as: rectangle)
                delegate?.latestPhotoOutput = photoOutput
            } catch {
                let photoOutput = PhotoOutput(image: ciImage, rectangle: nil, session: detectorManager.session)
                delegate?.latestPhotoOutput = photoOutput
            }
            
            try await Task.sleep(nanoseconds: .halfSecond)
            isDrawing = false
        }
    }

    func detectRectangle(ciImage: CIImage) throws -> CIRectangleFeature {
        let detectorBuilder = DetectorBuilder()
        let detector = try detectorBuilder.build(with: context)
        let transformedciImage = detectorManager.transform(ciImage)
        let rectangle = try detectorManager.detect(of: transformedciImage, with: detector)
        
        return rectangle
    }
    
    func drawPreviewLayer(using ciImage: CIImage, as rectangle: CIRectangleFeature) async throws -> PhotoOutput {
        // MARK: - 단순히 View의 크기만 구해서 계산하는 데 사용하는 거라 사용해도 괜찮을 듯.
        // 다만, rootVC이 변경되면 수정이 필요하게 됨. OCP에 취약
        // 앱의 rootVC이 바뀔 것 같지는 않다고 판단하여 사용하기로 결정함.
        
        // !!!: 과제 명세 상, 혹시 모를 iOS 하위 버전에 대한 호환성을 고려하여 수정하지 않았음.
        let windows = await UIApplication.shared.windows
        guard let photoDetectorViewController = await windows.first?.rootViewController else { throw UIError.invalidRootViewController }
        
        let shapeLayer = await createShapeLayer(using: ciImage, as: rectangle, to: photoDetectorViewController)
        
        let rectangle = Rectangle(topLeft: rectangle.topLeft,
                                  topRight: rectangle.topRight,
                                  bottomLeft: rectangle.bottomLeft,
                                  bottomRight: rectangle.bottomRight,
                                  layer: shapeLayer)
        
        let photoOutput = PhotoOutput(image: ciImage, rectangle: rectangle, session: detectorManager.session)
        
        return photoOutput
    }
    
    func createShapeLayer(using ciImage: CIImage, as rectangle: CIRectangleFeature, to viewController: UIViewController) async -> CAShapeLayer {
        // MARK: - 이미지의 크기와 뷰의 크기를 사용하여 비율 계산
        let scaleX = await viewController.view.bounds.width / ciImage.extent.width
        let scaleY = await viewController.view.bounds.height / ciImage.extent.height
        
        // MARK: - 사각형의 좌표를 뷰의 좌표계로 변환
        let topLeft = CGPoint(x: rectangle.topLeft.x * scaleX-Constants.defaultXAxisCorrection, y: rectangle.topLeft.y * scaleY)
        let topRight = CGPoint(x: rectangle.topRight.x * scaleX+Constants.defaultYAxisCorrection, y: rectangle.topRight.y * scaleY)
        let bottomLeft = CGPoint(x: rectangle.bottomLeft.x * scaleX-Constants.defaultXAxisCorrection, y: rectangle.bottomLeft.y * scaleY)
        let bottomRight = CGPoint(x: rectangle.bottomRight.x * scaleX+Constants.defaultXAxisCorrection, y: rectangle.bottomRight.y * scaleY)
        
        // MARK: - 대각, 기울임 등의 상황에서도 사각형을 그려줌
        let path = UIBezierPath()
        path.move(to: topLeft)
        path.addLine(to: topRight)
        path.addLine(to: bottomRight)
        path.addLine(to: bottomLeft)
        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.mainColorAlpha50.cgColor
        shapeLayer.strokeColor = UIColor.subColor.cgColor
        shapeLayer.lineWidth = 3
        
        return shapeLayer
    }
}
