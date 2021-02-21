//
//  String+urlComponents.swift
//  API
//
//  Created by Joanna Zatorska on 16/02/2021.
//  Copyright © 2021 com.zatorska. All rights reserved.
//

import Foundation

extension String {
    var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "omdbapi.com"
        components.path = self
        return components
    }
}
