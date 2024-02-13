//
//  ViewController.swift
//  PhotoDetector
//
//  Created by imseonghyeon on 2/1/24.
//

import UIKit
import AVFoundation

final class PhotoDetectorViewController: UIViewController {
    // MARK: - Namespace
    private enum Constants {
        static let defaultLayoutMargin: Double = 10.0
        static let defaultAutomatic: Double = 1.5
    }
    
    // MARK: - Dependencies
    private var viewModel: PhotoDetectorViewModelProtocol?
    private var timeCounter: Double = 0.0
    private var timer: Timer?
    
    // MARK: - Flag Property
    private var isAutomatic: Bool = false
        
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startDisplay()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endDisplay()
    }
    
    private func bind() {
        viewModel?.photoListener = updateRectangleView
        viewModel?.thumbnailListener = updateThumbnailView
    }
            
    private func startDisplay() {
        viewModel = PhotoDetectorViewModel()

        do {
            try viewModel?.observe()
        } catch {
            print(error)
        }
    }
    
    private func endDisplay() {
        viewModel?.release()
        viewModel = nil
    }
    
    // MARK: - View Elements
    private lazy var navigationLeftButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
        uiBarButtonItem.tintColor = .white
        return uiBarButtonItem
    }()
    
    private lazy var navigationRightButton: UIBarButtonItem = {
        let uiBarButtonItem = UIBarButtonItem(title: "자동/수동", style: .plain, target: self, action: #selector(toggleAutomaticButton))
        uiBarButtonItem.tintColor = .white
        
        return uiBarButtonItem
    }()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        
        return layer
    }()
    
    private lazy var wrappedPreviewLayerView: UIView = {
        let view = UIView()
        view.layer.addSublayer(previewLayer)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let thumbnail: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(thumbnailHandler), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let shutterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.dashed.inset.filled"), for: .normal)
        button.addTarget(self, action: #selector(shutterButtonHandler), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.addsubViews(thumbnail, shutterButton)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
}

// MARK: - Action Handler
extension PhotoDetectorViewController {
    @objc
    private func thumbnailHandler() {
        let photoPreviewViewController = PhotoPreviewViewController()
        photoPreviewViewController.delegate = self
        navigationController?.pushViewController(photoPreviewViewController, animated: true)
    }
    
    @objc
    private func shutterButtonHandler() {
        viewModel?.didTapShutterButton()
    }
    
    @objc
    private func toggleAutomaticButton() {
        isAutomatic.toggle()
    }
}

// MARK: - Configuration
extension PhotoDetectorViewController {
    private func configureView() {
        view.addsubViews(wrappedPreviewLayerView, bottomView)
        
        configureNavigationBar()
        configureConstraint()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = .defaultNavigationBarColor
        navigationItem.setLeftBarButton(navigationLeftButton, animated: true)
        navigationItem.setRightBarButton(navigationRightButton, animated: true)
    }
    
    private func configureConstraint() {
        configureConstraintWrappedPreviewLayerView()
        configureConstraintBottomView()
        configureConstraintThumbnail()
        configureConstraintShutterButton()
    }
    
    private func configureConstraintWrappedPreviewLayerView() {
        NSLayoutConstraint.activate([
            wrappedPreviewLayerView.topAnchor.constraint(equalTo: view.topAnchor),
            wrappedPreviewLayerView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            wrappedPreviewLayerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            wrappedPreviewLayerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            wrappedPreviewLayerView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 8.0)
        ])
    }
    
    private func configureConstraintBottomView() {
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureConstraintThumbnail() {
        NSLayoutConstraint.activate([
            thumbnail.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: Constants.defaultLayoutMargin),
            thumbnail.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -Constants.defaultLayoutMargin * 3),
            thumbnail.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: Constants.defaultLayoutMargin),
            thumbnail.widthAnchor.constraint(equalTo: thumbnail.heightAnchor),
        ])
    }
    
    private func configureConstraintShutterButton() {
        NSLayoutConstraint.activate([
            shutterButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: Constants.defaultLayoutMargin),
            shutterButton.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor),
            shutterButton.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor)
        ])
    }
    
    private func updateRectangleView(photo: PhotoOutput) {
        previewLayer.session = photo.session
        
        Task { @MainActor in
            previewLayer.sublayers?.removeSubrange(1...)
        }
        
        guard let rectangle = photo.rectangle else {
            resetTimer()
            return
        }
        
        Task { @MainActor in
            previewLayer.addSublayer(rectangle.layer)
            
            if isAutomatic {
                setTimer()
                timer?.fire()
            }
            
            if timeCounter >= Constants.defaultAutomatic {
                shutterButtonHandler()
                resetTimer()
            }
        }
    }
    
    private func setTimer() {
        timer = Timer(timeInterval: .halfSecond, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            timeCounter += .halfSecond
        }
    }
    
    private func resetTimer() {
        timer = nil
        timeCounter = .zero
        timer?.invalidate()
    }
    
    private func updateThumbnailView(thumbnail: UIImage) {
        self.thumbnail.setImage(thumbnail, for: .normal)
    }
}

// MARK: - PhotoDetectorViewControllerDelegate
extension PhotoDetectorViewController: PhotoDetectorViewControllerDelegate {
    func resetNavigationBarColor(_ self: PhotoPreviewViewController) {
        navigationController?.navigationBar.backgroundColor = .defaultNavigationBarColor
    }
}
