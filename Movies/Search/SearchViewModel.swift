//
//  SearchViewModel.swift
//  Movies
//
//  Created by Joanna Zatorska on 17/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import UIKit
import API
import Models

protocol SearchViewModelDelegate: AnyObject {
    func refresh()
    func didReceiveMovieDetails(_ details: MovieDetails)
    func showError(_ error: ApiError)
}

protocol SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate? { get set }
    var movies: [Movie] { get }
    func textDidChange(to term: String?)
    func selectedMovie(id: String)
    func loadNextPage()
}

class SearchViewModel: SearchViewModelProtocol {
    let api: APIProtocol
    weak var delegate: SearchViewModelDelegate?
    
    var searchHandler: SearchHandlerProtocol
    var movies = [Movie]()
    var totalCount = 0
    var currentSearchTerm: String?
    
    init(with api: APIProtocol, searchHandler: SearchHandlerProtocol) {
        self.api = api
        self.searchHandler = searchHandler
        self.searchHandler.delegate = self
    }
    
    func textDidChange(to term: String?) {
        guard let term = term,
              !term.isEmpty else {
            movies = []
            totalCount = 0
            delegate?.refresh()
            return
        }
        currentSearchTerm = term
        searchHandler.searchFor(term, page: 1)
    }
    
    func selectedMovie(id: String) {
        api.getMovieDetails(id: id) { [weak self] result in
            runOnMainThread {
                switch result {
                case let .success(details):
                    self?.delegate?.didReceiveMovieDetails(details)
                case let .failure(error):
                    self?.delegate?.showError(error)
                }
            }
        }
    }
    
    func loadNextPage() {
        guard let currentLastPage = movies.last?.page,
              currentLastPage * 10 < totalCount else { return }
        searchHandler.searchFor(currentSearchTerm, page: currentLastPage + 1)
    }
}

extension SearchViewModel: SearchHandlerDelegate {
    func onMoviesFound(movies: [Movie], totalCount: Int) {
        if movies.isEmpty {
            self.movies = []
        } else {
            self.movies.append(contentsOf: movies)
            self.movies = self.movies.removeDuplicates()
        }
        
        self.totalCount = totalCount
        delegate?.refresh()
    }
    
    func onApiError(_ error: ApiError) {
        runOnMainThread {
            self.delegate?.showError(error)
        }
    }
}

func runOnMainThread(action: @escaping () -> Void) {
    if Thread.isMainThread {
        action()
    } else {
        DispatchQueue.main.async { action() }
    }
}
