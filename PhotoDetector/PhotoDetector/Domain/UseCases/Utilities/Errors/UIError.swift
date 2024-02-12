//
//  UIError.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/12/24.
//

enum UIError: Error, CustomDebugStringConvertible {
    case invalidRootViewController
    
    var debugDescription: String {
        switch self {
        case .invalidRootViewController: "유효하지 않은 rootViewController 입니다."
        }
    }
}
