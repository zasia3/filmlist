//
//  MovieDetails.swift
//  Models
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation

public struct MovieDetails: Codable, Equatable {
    public let id: String
    public let title: String
    public let year: String
    public let genre: String
    public let duration: String
    public let rating: String
    public let plot: String
    public let votes: String
    public let popularity: String
    public let director: String
    public let writer: String
    public let actors: String
    
    enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case genre = "Genre"
        case duration = "Runtime"
        case rating = "imdbRating"
        case plot = "Plot"
        case votes = "imdbVotes"
        case popularity = "Metascore"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
    }
    
    public init(id: String,
                title: String,
                year: String,
                genre: String,
                duration: String,
                rating: String,
                plot: String,
                votes: String,
                popularity: String,
                director: String,
                writer: String,
                actors: String) {
        self.id = id
        self.title = title
        self.year = year
        self.genre = genre
        self.duration = duration
        self.rating = rating
        self.plot = plot
        self.votes = votes
        self.popularity = popularity
        self.director = director
        self.writer = writer
        self.actors = actors
    }
}
