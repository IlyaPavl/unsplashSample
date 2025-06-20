//
//  PhotoDetailViewModel.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

struct PhotoDetailViewModel {
    let imageUrl: String
    let username: String

    init(photo: Photo) {
        self.imageUrl = photo.urls.regular
        self.username = photo.user.username
    }
}
