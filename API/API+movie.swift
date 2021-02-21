//
//  API+movie.swift
//  API
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation
import Models

extension API {
    
    public func getMovies(searchTerm: String, page: Int, handler: @escaping (Result<Response, ApiError>) -> Void) {
        let endpoint = Endpoint.movies(key: apiKey, matching: searchTerm, page: page)
        request(endpoint, then: handler)
    }
    
    public func getMovieDetails(id: String, handler: @escaping (Result<MovieDetails, ApiError>) -> Void) {
        let endpoint = Endpoint.movieDetails(key: apiKey, id: id)
        request(endpoint, then: handler)
    }
}
