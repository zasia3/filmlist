//
//  Movie.swift
//  Models
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation

public struct Movie: Decodable{
    public let title: String
    public let imdbID: String
    public let year: String
    public let poster: String
    public let type: String
    public var page = 1
    
    enum CodingKeys: String, CodingKey {
        case imdbID = "imdbID"
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case type = "Type"
    }
    
    public init(title: String, imdbID: String, year: String, poster: String, type: String, page: Int) {
        self.title = title
        self.imdbID = imdbID
        self.year = year
        self.poster = poster
        self.type = type
        self.page = page
    }
}
extension Movie : Hashable {
    public static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.imdbID == rhs.imdbID
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(imdbID)
    }
}
