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
}

final class PhotosListViewModel: PhotosListViewModelProtocol {
    enum State {
        case idle
        case loading
        case loaded([Photo])
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

    init(photoFetcher: PhotoUrlsDataFetcher = PhotoUrlsDataFetcher()) {
        self.photoFetcher = photoFetcher
    }

    func loadPhotos() async {
        state = .loading
        do {
            let photos = try await photoFetcher.fetchPhotos()
            state = .loaded(photos)
        } catch {
            state = .error(error)
        }
    }

    func refresh() async {
        await loadPhotos()
    }
}
