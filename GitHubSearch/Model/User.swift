//
//  User.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  User model that contains a "User" returned from search information and "EntireUser" with more thorough
//  information

import Foundation

struct EntireUser: Decodable {
    let login: String
    let avatar_url: String
    let url: String
    let location: String?
    let email: String?
    let bio: String?
    let followers: Int?
    let following: Int?
    let created_at: String
    let repos_url: String
    let public_repos: Int?
}

struct User: Decodable {
    let login: String
    let avatar_url: String
    let url: String
}

struct jsonItems: Decodable {
    let items: [User]
}

