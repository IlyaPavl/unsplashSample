//
//  ImageCache.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 20.06.2025.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let urlCache = URLCache.shared

    func cachedImage(for url: URL) -> UIImage? {
        if let cachedResponse = urlCache.cachedResponse(for: URLRequest(url: url)) {
            return UIImage(data: cachedResponse.data)
        }
        return nil
    }

    func storeImage(_ data: Data, response: URLResponse) {
        guard let url = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
    }
}
