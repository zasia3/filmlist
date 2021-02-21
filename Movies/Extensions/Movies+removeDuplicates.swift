//
//  Movies+removeDuplicates.swift
//  Movies
//
//  Created by Joanna Zatorska on 20/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation
import Models

extension Array where Element == Movie {
    func removeDuplicates() -> Self {
        var moviesWithoutDuplicates = Self()
        forEach { movie in
            if !moviesWithoutDuplicates.contains(movie) {
                moviesWithoutDuplicates.append(movie)
            }
        }
        return moviesWithoutDuplicates
    }
}
