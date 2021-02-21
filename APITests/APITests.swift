//
//  APITests.swift
//  APITests
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import XCTest
import Models
@testable import API

class APITests: XCTestCase {

    var sut: API!
    fileprivate var sessionMock: URLSessionMock!
    override func setUpWithError() throws {
        sessionMock = URLSessionMock()
        sut = API(apiKey: "testKey", session: sessionMock)
    }

    func testRequestFailure() throws {
        sessionMock.error = ApiError.noData
        
        var apiError: ApiError?
        sut.getMovies(searchTerm: "test", page: 1) { result in
            switch result {
            case .success:
               break
            case .failure(let error):
                apiError = error
            }
        }
        XCTAssertNotNil(apiError)
    }
    
    func testRequestSuccess() throws {
        let testMovieDetails = MovieDetails(id: "test", title: "test", year: "test", genre: "test", duration: "test", rating: "test", plot: "test", votes: "test", popularity: "test", director: "test", writer: "test", actors: "test")
        sessionMock.data = try? JSONEncoder().encode(testMovieDetails)
        
        var returnedMovieDetails: MovieDetails?
        sut.getMovieDetails(id: "id") { result in
            switch result {
            case .success(let details):
                returnedMovieDetails = details
            case .failure:
                break
            }
        }
        XCTAssertEqual(returnedMovieDetails, testMovieDetails)
    }
}

private class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

private class URLSessionMock: URLSession {

    var data: Data?
    var error: Error?
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let data = self.data
        let error = self.error
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}
