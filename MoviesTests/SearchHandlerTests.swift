//
//  SearchHandlerTests.swift
//  MoviesTests
//
//  Created by Joanna Zatorska on 20/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import XCTest
import API
import Models
@testable import Movies

class SearchHandlerTests: XCTest {
    
    let testMovie = Movie(title: "test", imdbID: "test", year:  "test", poster:  "test", type:  "test", page: 1)
    
    var sut: SearchHandler!
    fileprivate var apiMock: APIMock!
    fileprivate var delegate: SearchHandlerDelegateMock!
    
    override func setUpWithError() throws {
        apiMock = APIMock()
        delegate = SearchHandlerDelegateMock()
        sut = SearchHandler(with: apiMock)
        sut.delegate = delegate
    }
    
    func testSettingTerm() throws {
        sut.searchFor("test")
        XCTAssertEqual(sut.termToSearch, "test")
    }
    
    func testSearchSuccess() throws {
        sut.termToSearch = "test"
        sut.page = 1
        let testResponse = Response(search: [testMovie], resultsCount: 10)
        apiMock.moviesResultToReturn = .success(testResponse)
        sut.search()
        XCTAssertEqual(sut.count, 1)
        XCTAssertEqual(delegate.moviesFound?.first, testMovie)
    }
    
    func testSearchFailure() throws {
        sut.termToSearch = "test"
        sut.page = 1
        apiMock.moviesResultToReturn = .failure(.noData)
        sut.search()
        XCTAssertEqual(delegate.returnedError?.description, ApiError.noData.description)
    }
}

private class APIMock: APIProtocol {
    
    var moviesResultToReturn: Result<Response, ApiError>?
    func getMovies(searchTerm: String, page: Int, handler: @escaping (Result<Response, ApiError>) -> Void) {
        guard let result = moviesResultToReturn else { return }
        handler(result)
    }
    
    func getMovieDetails(id: String, handler: @escaping (Result<MovieDetails, ApiError>) -> Void) {
    }
}

private class SearchHandlerDelegateMock: SearchHandlerDelegate {
    var moviesFound: [Movie]?
    func onMoviesFound(movies: [Movie], totalCount: Int) {
        moviesFound = movies
    }
    
    var returnedError: ApiError?
    func onApiError(_ error: ApiError) {
        returnedError = error
    }
}
