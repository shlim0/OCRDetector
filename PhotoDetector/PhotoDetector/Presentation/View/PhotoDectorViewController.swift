//
//  ViewController.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import UIKit
import CoreImage

protocol PhotoDetectorViewControllerConstantsProtocol {
    static var defaultSaturation: Double { get }
    static var defaultContrast: Double { get }
}

extension PhotoDetectorViewControllerConstantsProtocol {
    static var defaultSaturation: Double { 0.0 }
    static var defaultContrast: Double { 10.0 }
}

final class PhotoDetectorViewController: UIViewController {
    
    // MARK: - Dependency
    private let imageView = UIImageView()
    private var viewModel = PhotoDetectorViewModel(context: CIContext())
    
    // MARK: - ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
        configureView()
    }
}

// MARK: - Private Methods
extension PhotoDetectorViewController {
    private func configureView() {
        view.backgroundColor = .white
        view.addSubview(imageView)
    }
    
    private func configureImageView() {
        imageView.frame = view.bounds
        imageView.contentMode = .scaleAspectFit
    }
}

extension PhotoDetectorViewController: PhotoDetectorViewControllerConstantsProtocol {
    
}
