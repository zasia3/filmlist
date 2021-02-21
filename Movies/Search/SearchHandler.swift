//
//  SearchHandler.swift
//  Movies
//
//  Created by Joanna Zatorska on 17/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation
import API
import Models

protocol SearchHandlerDelegate: AnyObject {
    func onMoviesFound(movies: [Movie], totalCount: Int)
    func onApiError(_ error: ApiError)
}

protocol SearchHandlerProtocol {
    var delegate: SearchHandlerDelegate? { get set }
    func searchFor(_ term: String?, page: Int)
}

class SearchHandler: SearchHandlerProtocol {
    weak var delegate: SearchHandlerDelegate?
    
    let api: APIProtocol
    var movies = [Movie]()
    var count = 0
    
    let searchTimeDelay: TimeInterval = 0.5
    let minCharacters = 2
    
    var debounceTimer: Timer?
    var termToSearch: String?
    var page: Int?
    
    init(with api: APIProtocol) {
        self.api = api
    }
    
    func searchFor(_ term: String?, page: Int = 1) {
        debounceTimer?.invalidate()
        if term == nil {
            clear()
            return
        }
        
        if term != termToSearch {
            clear()
        }

        let timer = Timer(timeInterval: searchTimeDelay, target: self, selector: #selector(search), userInfo: nil, repeats: false)
        debounceTimer = timer
        RunLoop.main.add(timer, forMode: .default)
        self.page = page
        termToSearch = term
    }
    
    @objc func search() {

        guard let term = termToSearch,
              let page = page else { return }
        
        api.getMovies(searchTerm: term, page: page) { [weak self] result in
            switch result {
            case let .success(response):
                self?.movies = response.search.map { movie in
                    var movieWithPage = movie
                    movieWithPage.page = page
                    return movieWithPage
                }
                self?.count = response.resultsCount
                runOnMainThread {
                    self?.refreshSearch()
                }
            case let .failure(error):
                self?.delegate?.onApiError(error)
            }
        }
    }
    
    func clear() {
        clearSearch()
        refreshSearch()
    }

    func clearSearch() {
        movies = []
        termToSearch = nil
    }

    func refreshSearch() {
        delegate?.onMoviesFound(movies: movies, totalCount: count)
    }
}
