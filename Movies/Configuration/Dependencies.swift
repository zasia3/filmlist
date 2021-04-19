//
//  Navigator.swift
//  Movies
//
//  Created by Joanna Zatorska on 20/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import UIKit
import API
import Models

final class Dependencies {
    
    private let api = API(apiKey: Keys.moviesApi.rawValue)
    private lazy var searchHandler = SearchHandler(with: api)
    
    func createSearchViewModel() -> SearchViewModelProtocol {
        return SearchViewModel(with: api, searchHandler: searchHandler)
    }
}
