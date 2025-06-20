//
//  RequestParamsBuilder.swift
//  UnsplashImageList
//
//  Created by Илья Павлов on 19.06.2025.
//


import Foundation

protocol RequestParamsBuilder {
    func setParameter(key: String, value: String?) -> Self
    func setParameters(parameters: [String: String]) -> Self
    func build() -> [String: String]
}

class URLRequestParamsBuilder: RequestParamsBuilder {
    private var parameters: [String: String] = [:]
    
    func setParameter(key: String, value: String?) -> Self {
        parameters[key] = value
        return self
    }
    
    func setParameters(parameters: [String : String]) -> Self {
        for (key, value) in parameters {
            self.parameters[key] = value
        }
        return self
    }
    
    func build() -> [String : String] {
        return parameters
    }
}