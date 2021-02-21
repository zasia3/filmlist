//
//  Endpoint.swift
//  API
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation

struct Endpoint {
    let queryItems: [URLQueryItem]?
    
    static func movies(key: String, matching name: String, page: Int) -> Endpoint {
        
        return Endpoint(
            queryItems: [
                URLQueryItem(name: "apikey", value: key),
                URLQueryItem(name: "s", value: name),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "type", value: "movie")
            ]
        )
    }
    
    static func movieDetails(key: String, id: String) -> Endpoint {
        
        return Endpoint(
            queryItems: [
                URLQueryItem(name: "apikey", value: key),
                URLQueryItem(name: "i", value: id)
            ]
        )
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "omdbapi.com"
        return components
    }
    var url: URL? {
        var components = urlComponents
        components.queryItems = queryItems
        return components.url
    }
}
