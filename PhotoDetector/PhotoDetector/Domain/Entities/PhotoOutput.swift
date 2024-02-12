//
//  Rectangle.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/8/24.
//

import CoreImage
import AVFoundation

struct PhotoOutput {
    let image: CIImage
    let rectangle: Rectangle?
    let session: AVCaptureSession
}
