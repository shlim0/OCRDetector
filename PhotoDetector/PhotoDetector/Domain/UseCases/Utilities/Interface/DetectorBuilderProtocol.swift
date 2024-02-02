//
//  DetectorBuilderProtocol.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import CoreImage

protocol DetectorBuilderProtocol {
    var type: String { get }
    var options: [String : Any]? { get }
    func build(context: CIContext) throws -> CIDetector
}

extension DetectorBuilderProtocol {
    var type: String { CIDetectorTypeRectangle }
    var options: [String : Any]? { [CIDetectorAccuracy: CIDetectorAccuracyHigh] }
}
