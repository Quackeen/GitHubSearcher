//
//  Repository.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  Repository model to store user repositories

import Foundation

struct Repository: Decodable {
    let name: String
    let url: String
    let forks: Int
    let stargazers: Int

    enum CodingKeys: String, CodingKey {
        case name
        case url = "html_url"
        case forks = "forks_count"
        case stargazers = "stargazers_count"
    }

}
