//
//  Photo.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

struct Photo: Codable, Identifiable, Hashable {
    let id: String
    let description: String?
    let altDescription: String?
    let color: String
    let likes: Int
    let urls: PhotoUrls
    let user: User
    
    enum CodingKeys: String, CodingKey {
        case id, description, color, likes, urls, user
        case altDescription = "alt_description"
    }
    
    var displayDescription: String {
        description ?? altDescription ?? "No description to show"
    }
}

struct PhotoUrls: Codable, Hashable {
    let thumb: String
    let regular: String
}

struct User: Codable, Hashable {
    let username: String
}
