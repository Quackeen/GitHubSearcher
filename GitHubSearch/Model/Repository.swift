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
    let html_url: String
    let forks_count: Int
    let stargazers_count: Int
}
