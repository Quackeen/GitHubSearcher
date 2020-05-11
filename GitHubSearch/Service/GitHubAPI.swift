//
//  GitHubAPI.swift
//  GitHubSearch
//
//  Created by Consultant on 5/10/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

struct GitHubAPI {

    let head = "https://api.github.com/search/users?q="

    var searchQuery: String!

    init(_ search: String? = nil) {
        self.searchQuery = search
    }

    var searchURL: URL? {
        guard let search = searchQuery else { return nil }
        let formatedSearch = search.replacingOccurrences(of: " ", with: "%20")
        return URL(string: head + formatedSearch)
    }


}
