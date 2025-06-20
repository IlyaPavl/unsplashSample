//
//  WebImageView.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 20.06.2025.
//

import UIKit

class WebImageView: UIImageView {
    private var currentURLString: String?
    private var activityIndicator: UIActivityIndicatorView?

    var onLoadError: ((Error) -> Void)?

    func set(imageURL: String?) {
        currentURLString = imageURL
        setupActivityIndicator()
        
        guard let imageURL,
              let url = URL(string: imageURL) else {
            stopActivityIndicator()
            return
        }

        if loadFromCache(url) { return }

        fetchImage(from: url)
    }

    private func setupActivityIndicator() {
        activityIndicator?.removeFromSuperview()
        activityIndicator = UIActivityIndicatorView(style: .medium)
        guard let activityIndicator else { return }

        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
        activityIndicator.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleTopMargin,
            .flexibleBottomMargin
        ]
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    private func stopActivityIndicator() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
    }

    private func loadFromCache(_ url: URL) -> Bool {
        if let cachedImage = ImageCache.shared.cachedImage(for: url) {
            stopActivityIndicator()
            self.image = cachedImage
            return true
        }
        return false
    }

    private func fetchImage(from url: URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.handleResponse(data: data, response: response, error: error)
            }
        }
        dataTask.resume()
    }

    private func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        stopActivityIndicator()

        if let error {
            onLoadError?(error)
            return
        }

        guard let data,
              let response,
              let loadedImage = UIImage(data: data) else {
            onLoadError?(NSError(domain: "WebImageView",code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"]))
            return
        }

        self.image = loadedImage
        ImageCache.shared.storeImage(data, response: response)
    }
}
