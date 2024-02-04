//
//  ViewController.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import UIKit

final class PhotoDetectorViewController: UIViewController {
    // MARK: - Namespace
    private enum Constants {
        static let defaultLayoutMargin: Double = 10.0
    }
        
    // MARK: - Dependency
    private var viewModel = PhotoDetectorViewModel(context: CIContext())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        bind()
    }
    
    // MARK: - View Elements
    private let navigationLeftButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: PhotoDetectorViewController.self, action: nil)
        uiBarButtonItem.tintColor = .white
        return uiBarButtonItem
    }()
    
    private let navigationRightButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(title: "자동/수동", style: .plain, target: PhotoDetectorViewController.self, action: nil)
        uiBarButtonItem.tintColor = .white
        
        return uiBarButtonItem
    }()
    
    private let cameraView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var thumbnail: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(thumbnailHandler), for: .touchUpInside)
        
        return button
    }()
    
    private let shutterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.dashed.inset.filled"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
}

// MARK: - Action Handler
extension PhotoDetectorViewController {
    @objc
    private func thumbnailHandler() {
        let photoPreviewViewController = PhotoPreviewViewController()
        navigationController?.pushViewController(photoPreviewViewController, animated: true)
    }
}

// MARK: - Configuration
extension PhotoDetectorViewController {
    private func configureView() {
        view.backgroundColor = .white
        view.addsubViews(cameraView, thumbnail, shutterButton)
        configureNavigationBar()
        configureConstraint()
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .defaultNavigationBarColor
        navigationItem.setLeftBarButton(navigationLeftButton, animated: true)
        navigationItem.setRightBarButton(navigationRightButton, animated: true)
    }
    
    private func configureConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            cameraView.bottomAnchor.constraint(equalTo: thumbnail.topAnchor, constant: -Constants.defaultLayoutMargin),
            cameraView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            thumbnail.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.defaultLayoutMargin),
            thumbnail.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shutterButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            shutterButton.centerYAnchor.constraint(equalTo: thumbnail.centerYAnchor)
        ])
    }
    
    private func bind() {
        viewModel.rectangleListener = updateRectangleView
        viewModel.thumbnailListener = updateThumbnailView
    }
    
    private func updateRectangleView() {
        
    }
    
    private func updateThumbnailView() {
        
    }
}
