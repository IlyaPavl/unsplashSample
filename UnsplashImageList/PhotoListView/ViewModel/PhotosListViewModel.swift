//
//  PhotosListViewModel.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import Foundation

protocol PhotosListViewModelProtocol: AnyObject {
    var onStateChanged: ((PhotosListViewModel.State) -> Void)? { get set }
    var state: PhotosListViewModel.State { get }
    func loadPhotos() async
    func refresh() async
    func removePhoto(_ photo: Photo)
}

final class PhotosListViewModel: PhotosListViewModelProtocol {
    enum State {
        case idle
        case loading
        case loaded([Photo])
        case empty
        case error(Error)
    }

    var onStateChanged: ((State) -> Void)?

    private let photoFetcher: PhotosDataFetcherProtocol
    private(set) var state: State = .idle {
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
