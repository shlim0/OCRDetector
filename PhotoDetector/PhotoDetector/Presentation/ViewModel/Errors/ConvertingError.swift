//
//  ConvertError.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

enum ConvertingError: Error, CustomDebugStringConvertible {
    case failedConvertingUIImageToCIImage
    
    var debugDescription: String {
        switch self {
            case .failedConvertingUIImageToCIImage: "failedConvertingUIImageToCIImage"
        }
    }
}

