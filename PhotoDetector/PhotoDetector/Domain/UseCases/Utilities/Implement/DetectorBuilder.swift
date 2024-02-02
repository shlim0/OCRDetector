//
//  DetectorBuilder.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import CoreImage

struct DetectorBuilder: DetectorBuilderProtocol {
    func build(context: CIContext) throws -> CIDetector {
        guard let detector = CIDetector(ofType: type, context: context, options: options) else {
            throw DetectorBuilderError.failedBulidingDetector
        }
        return detector
    }
}
