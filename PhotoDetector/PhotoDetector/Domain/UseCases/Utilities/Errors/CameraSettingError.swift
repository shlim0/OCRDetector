//
//  CameraSettingError.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/8/24.
//

enum CameraSettingError: Error, CustomDebugStringConvertible {
    case invalidDevice
    case invalidPreset
    
    var debugDescription: String {
        switch self {
        case .invalidDevice: "디바이스 인식에 실패했습니다."
        case .invalidPreset: "사용 가능한 Preset이 없습니다."
        }
    }
    
    enum InvalidInput: Error, CustomDebugStringConvertible {
        case video
        case photo
        
        var debugDescription: String {
            switch self {
            case .video: "사용 가능한 Video Input이 없습니다."
            case .photo: "사용 가능한 Photo Input이 없습니다."
            }
        }
    }
    
    enum InvalidOutput: Error, CustomDebugStringConvertible {
        case video
        case photo
        
        var debugDescription: String {
            switch self {
            case .video: "사용 가능한 Video Output이 없습니다."
            case .photo: "사용 가능한 Photo Output이 없습니다."
            }
        }
    }
}
