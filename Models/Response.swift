//
//  Response.swift
//  Models
//
//  Created by Joanna Zatorska on 17/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation

public struct Response: Decodable {
    public let search: [Movie]
    public let resultsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case resultsCount = "totalResults"
    }
    
    public init(search: [Movie], resultsCount: Int) {
        self.search = search
        self.resultsCount = resultsCount
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let movies = try? container.decode([Movie].self, forKey: .search)
        search = movies ?? []
        var count = 0
        if let countString = try? container.decode(String.self, forKey: .resultsCount) {
            count = Int(countString) ?? 0
        }
        resultsCount = count
    }
}
