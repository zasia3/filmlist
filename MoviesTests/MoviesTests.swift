//
//  MoviesTests.swift
//  MoviesTests
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import XCTest
import Models
@testable import Movies

class MoviesTests: XCTestCase {

    func testRemovingDuplicates() throws {
        let movie1 = Movie(title: "test", imdbID: "id1", year:  "test", poster:  "test", type:  "test", page: 2)
        let movie2 = Movie(title: "test", imdbID: "id1", year:  "test", poster:  "test", type:  "test", page: 2)
        let movie3 = Movie(title: "test", imdbID: "id2", year:  "test", poster:  "test", type:  "test", page: 2)
        let movies = [movie1, movie2, movie3]
        let moviewWithoutDuplicates = movies.removeDuplicates()
        XCTAssert(moviewWithoutDuplicates.count == 2)
        XCTAssert(moviewWithoutDuplicates.first == movie1)
        XCTAssert(moviewWithoutDuplicates.last == movie3)
    }
}
