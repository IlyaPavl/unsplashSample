//
//  PhotosDataFetcher.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import Foundation

protocol PhotosDataFetcherProtocol {
    func fetchPhotos() async throws -> [Photo]
}

struct PhotoUrlsDataFetcher: PhotosDataFetcherProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchPhotos() async throws -> [Photo] {
        let result: [Photo] = try await networkService.request(
            path: API.Endpoints.photos,
            method: .get,
            parameters: nil,
            headers: nil
        )
        return result
    }
}
