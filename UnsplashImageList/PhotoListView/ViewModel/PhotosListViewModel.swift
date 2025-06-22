//
//  PhotosListViewModel.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import Foundation

typealias PhotosListState = LoadingState<Photo>

protocol PhotosListViewModelProtocol: AnyObject {
    var onStateChanged: ((PhotosListState) -> Void)? { get set }
    var state: PhotosListState { get }
    func loadPhotos() async
    func refresh() async
    func removePhoto(_ photo: Photo)
}

final class PhotosListViewModel: PhotosListViewModelProtocol {

    var onStateChanged: ((PhotosListState) -> Void)?

    private let photoFetcher: PhotosDataFetcherProtocol
    private(set) var state: PhotosListState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.onStateChanged?(self.state)
            }
        }
    }

    init(photoFetcher: PhotosDataFetcherProtocol = PhotoUrlsDataFetcher()) {
        self.photoFetcher = photoFetcher
    }

    func loadPhotos() async {
        state = .loading
        do {
            let photos = try await photoFetcher.fetchPhotos()
            state = photos.isEmpty ? .empty : .loaded(photos)
        } catch {
            state = .error(error)
        }
    }

    func refresh() async {
        await loadPhotos()
    }
    
    func removePhoto(_ photo: Photo) {
        guard case .loaded(let photos) = state else { return }
        let updatedPhotos = photos.filter { $0.id != photo.id }
        state = updatedPhotos.isEmpty ? .empty : .loaded(updatedPhotos)
    }
}
