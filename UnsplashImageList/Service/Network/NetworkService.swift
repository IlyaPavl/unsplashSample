//
//  NetworkService.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(path: String,
                               method: HTTPMethodType,
                               parameters: URLRequestParamsBuilder?,
                               headers: [String: String]?) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(
        path: String,
        method: HTTPMethodType,
        parameters: URLRequestParamsBuilder?,
        headers: [String : String]?
    ) async throws -> T {
        let allParameters = (parameters ?? URLRequestParamsBuilder())
            .setParameter(key: "client_id", value: API.clientID)
            .build()
        
        guard let url = createURL(path: path, parameters: allParameters) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    private func createURL(path: String, parameters: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        return components.url
    }
}
