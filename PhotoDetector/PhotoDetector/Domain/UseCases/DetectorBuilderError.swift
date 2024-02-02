//
//  DetectorBuilderError.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

enum DetectorBuilderError: Error, CustomDebugStringConvertible {
    case failedBulidingDetector
    
    var debugDescription: String {
        switch self {
        case .failedBulidingDetector: "Detector를 만드는데 실패했습니다."
        }
    }
}
