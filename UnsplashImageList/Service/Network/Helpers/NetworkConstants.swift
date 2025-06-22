//
//  NetworkConstants.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import Foundation

public enum API {
    static let scheme = "https"
    static let host = "api.unsplash.com"
    static let clientID = "aFXVI-T1kTumK4ynz7dj3VlCTvdHknY0pPcgBTciw9o"

    enum Endpoints {
        static let photos = "/photos"
    }
}

public enum NetworkError: Error, LocalizedError {
    case invalidURL
    case serverError
    case decodingError
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .serverError:
            return "Server error occurred"
        case .decodingError:
            return "Failed to decode data"
        }
    }
}

public enum HTTPMethodType: String {
    case get = "GET"
}

public enum LoadingState<T> {
    case idle
    case loading
    case loaded([T])
    case empty
    case error(Error)
}
