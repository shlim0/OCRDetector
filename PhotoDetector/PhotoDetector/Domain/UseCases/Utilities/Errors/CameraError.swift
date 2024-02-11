//
//  CameraError.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/8/24.
//

enum CameraError: Error {
    enum InvalidOutput: Error, CustomDebugStringConvertible {
        case video
        case photo
        
        var debugDescription: String {
            switch self {
            case .video: "Video Output에 오류가 발생했습니다."
            case .photo: "Photo Output에 오류가 발생했습니다."
            }
        }
    }
}
