//
//  ConvertError.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

enum ConversionError: Error, CustomDebugStringConvertible {
    case failedConversionUIImageToCIImage
    
    var debugDescription: String {
        switch self {
            case .failedConversionUIImageToCIImage: "UIImage를 CIImage로 변환하는데 실패했습니다."
        }
    }
}

