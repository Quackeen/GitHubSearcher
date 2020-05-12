//
//  GitHubAPI.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/10/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

struct GitHubAPI {

    let head = "https://api.github.com/search/users?q="

    let searchQuery: String

    init(_ search: String) {
        searchQuery = search
    }

    var searchURL: URL? {
        let formatedSearch = searchQuery.replacingOccurrences(of: " ", with: "%20")
        return URL(string: head + formatedSearch)
    }

}
