//
//  PhotoDetailView.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import UIKit

final class PhotoDetailView: UIViewController {
    private let photoDetailVM: PhotoDetailViewModel
    private let imageView = WebImageView()
    private let scrollView = UIScrollView()
    
    init(photo: Photo) {
        self.photoDetailVM = PhotoDetailViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setImage()
    }
    
    private func setImage() {
        imageView.set(imageURL: photoDetailVM.imageUrl)
    }
    
    private func showErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Loading error",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)
        alert.addAction(.init(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}

private extension PhotoDetailView {
    func setupUI() {
        title = photoDetailVM.username
        view.backgroundColor = .systemBackground
        [scrollView, imageView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        setupConsraints()
        imageView.onLoadError = { [weak self] error in
            self?.showErrorAlert(error)
        }
    }
    
    func setupConsraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
        ])
    }
}

extension PhotoDetailView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
