//
//  ApiError.swift
//  API
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation

public enum ApiError: Error {
    case invalidUrl
    case decode(String)
    case network(NetworkError)
    case noData
    case unknown
    
    public var description: String {
        switch self {
        case .invalidUrl:
            return "Invalid url"
        case .decode(let message):
            return message
        case .network(let error):
            return error.description
        case .noData:
            return "No data returned"
        case .unknown:
            return "Unknown error"
        }
    }
}

public enum NetworkError: Error {
    case server
    case other(Error)
    case unknown
    
    init(with statusCode: Int) {
        switch statusCode {
        case 500:
            self = .server
        default:
            self = .unknown
        }
    }
    
    public var description: String {
        switch self {
        case .server:
            return "Server error"
        case .other(let error):
            return error.localizedDescription
        case .unknown:
            return "Unknown error"
        }
    }
}
