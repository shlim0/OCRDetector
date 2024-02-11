//
//  DetectorBuilder.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import CoreImage

struct DetectorBuilder: DetectorBuilderProtocol {
    func build(with: CIContext) throws -> CIDetector {
        guard let detector = CIDetector(ofType: type, context: with, options: options) else {
            throw DetectorError.Builder.failedBulidingDetector
        }
        return detector
    }
}
