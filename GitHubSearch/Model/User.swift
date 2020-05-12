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
    let avatarUrl: String
    let url: String
    let location: String?
    let email: String?
    let bio: String?
    let followers: Int
    let following: Int
    let created: String
    let reposUrl: String
    let publicRepoCount: Int

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case url, location, email, bio, followers, following
        case created = "created_at"
        case reposUrl = "repos_url"
        case publicRepoCount = "public_repos"
    }
}

struct User: Decodable {
    let login: String
    let avatarUrl: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case url
    }
}

struct JsonItems: Decodable {
    let items: [User]
}
