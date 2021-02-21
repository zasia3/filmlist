//
//  API.swift
//  API
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation
import Models

public protocol APIProtocol {
    func getMovies(searchTerm: String, page: Int, handler: @escaping (Result<Response, ApiError>) -> Void)
    func getMovieDetails(id: String, handler: @escaping (Result<MovieDetails, ApiError>) -> Void)
}

public final class API: APIProtocol {
    typealias DecodeFunction<T: Decodable> = (Data) -> T?
    typealias APIResult<T: Decodable> = (Result<T, ApiError>) -> Void
    
    private let session: URLSession
    let apiKey: String
    
    public init(apiKey: String, session: URLSession = URLSession.shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func request<T: Decodable>(_ endpoint: Endpoint, then handler: @escaping APIResult<T>) {
        guard let url = endpoint.url else {
            return handler(.failure(.invalidUrl))
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                handler(.failure(.network(.other(error))))
                return
            }
            guard let data = data else {
                handler(.failure(.noData))
                return
            }
            guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                handler(.failure(ApiError.decode("Could not decode \(T.self)")))
                return
            }
            
            handler(.success(decodedData))
        }
        task.resume()
    }
}
