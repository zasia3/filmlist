//
//  SearchViewModelTests.swift
//  MoviesTests
//
//  Created by Joanna Zatorska on 20/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import XCTest
import API
import Models
@testable import Movies

class SearchViewModelTests: XCTestCase {
    let testMovie = Movie(title: "test", imdbID: "test", year:  "test", poster:  "test", type:  "test", page: 2)
    let testMovieDetails = MovieDetails(id: "test", title: "test", year: "test", genre: "test", duration: "test", rating: "test", plot: "test", votes: "test", popularity: "test", director: "test", writer: "test", actors: "test")
    
    var sut: SearchViewModel!
    fileprivate var apiMock: APIMock!
    fileprivate var searchHandlerMock: SearchHandlerMock!
    fileprivate var delegateMock: SearchViewModelDelegateMock!
    
    override func setUpWithError() throws {
        apiMock = APIMock()
        searchHandlerMock = SearchHandlerMock()
        delegateMock = SearchViewModelDelegateMock()
        sut = SearchViewModel(with: apiMock, searchHandler: searchHandlerMock)
        sut.delegate = delegateMock
    }

    func testChangesIntoEmptyTerm() throws {
        sut.totalCount = 10
        sut.textDidChange(to: nil)
        XCTAssertEqual(sut.totalCount, 0)
    }
    func testChangesInTerm() throws {
        let testTerm = "test"
        sut.textDidChange(to: testTerm)
        XCTAssertEqual(sut.currentSearchTerm, testTerm)
        XCTAssertEqual(searchHandlerMock.searchedForTerm, testTerm)
        XCTAssertEqual(searchHandlerMock.searchedPage, 1)
    }
    
    func testGettingNextPage() throws {
        sut.currentSearchTerm = "test"
        sut.totalCount = 100
        sut.movies = [testMovie]
        sut.loadNextPage()
        XCTAssertEqual(searchHandlerMock.searchedPage, 3)
    }
    
    func testGettingMovieDetailsWithError() throws {
        apiMock.moviesResultToReturn = .failure(.noData)
        sut.selectedMovie(id: "test")
        XCTAssertEqual(delegateMock.returnedError?.description, ApiError.noData.description)
    }
    
    func testGettingMovieDetailsSuccess() throws {
        apiMock.moviesResultToReturn = .success(testMovieDetails)
        sut.selectedMovie(id: "test")
        XCTAssertEqual(delegateMock.returnedMovieDetails, testMovieDetails)
    }
}

private class APIMock: APIProtocol {
    
    func getMovies(searchTerm: String, page: Int, handler: @escaping (Result<Response, ApiError>) -> Void) {
    }
    
    var moviesResultToReturn: Result<MovieDetails, ApiError>?
    func getMovieDetails(id: String, handler: @escaping (Result<MovieDetails, ApiError>) -> Void) {
        guard let result = moviesResultToReturn else { return }
        handler(result)
    }
}

private class SearchHandlerMock: SearchHandlerProtocol {
    var delegate: SearchHandlerDelegate?
    
    var searchedForTerm: String?
    var searchedPage: Int?
    func searchFor(_ term: String?, page: Int) {
        searchedForTerm = term
        searchedPage = page
    }
}

private class SearchViewModelDelegateMock: SearchViewModelDelegate {
    func refresh() {
    }
    
    var returnedMovieDetails: MovieDetails?
    func didReceiveMovieDetails(_ details: MovieDetails) {
        returnedMovieDetails = details
    }
    
    var returnedError: ApiError?
    func showError(_ error: ApiError) {
        returnedError = error
    }
}
