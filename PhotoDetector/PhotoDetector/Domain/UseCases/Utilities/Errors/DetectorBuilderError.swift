//
//  DetectorBuilderError.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//


enum DetectorError: Error, CustomDebugStringConvertible {
    case failedConversionToCIRectangleFeature
    case notFoundCIRectangleFeature
    
    var debugDescription: String {
        switch self {
        case .failedConversionToCIRectangleFeature: "CIRectangleFeature로 형변환에 실패했습니다."
        case .notFoundCIRectangleFeature: "CIRectangleFeature 탐색에 실패했습니다."
        }
    }
    
    enum Builder: Error, CustomDebugStringConvertible {
        case failedBulidingDetector
        
        var debugDescription: String {
            switch self {
            case .failedBulidingDetector: "Detector를 만드는데 실패했습니다."
            }
        }
    }
}

