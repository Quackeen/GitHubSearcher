//
//  MockService.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/11/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation
@testable import GitHubSearch

class MockService {
    let bundle = Bundle(for: MockService.self)

    func fetchTomSearch(_ completion: UserHandler) {
        guard let filePath = bundle.path(forResource: "sampleSearchTom",
                                         ofType: "json") else {
                                            fatalError("missing file in test: sampleSearchTom.json")
        }
        let url = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: url)
            let items = try JSONDecoder().decode(JsonItems.self, from: data)
            let users = items.items
            completion(.success(users))
        } catch {
            completion(.failure(.badDecoder(error.localizedDescription)))
        }
    }

    func fetchMojomboRepos(_ completion: RepoHandler) {
        guard let filePath = bundle.path(forResource: "sampleRepoUrlMojombo",
                                         ofType: "json") else {
                                            fatalError("missing file in test: sampleRepoUrlMojombo.json")
        }
        let url = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: url)
            let repos = try JSONDecoder().decode([Repository].self, from: data)
            completion(.success(repos))
        } catch {
            completion(.failure(.badDecoder(error.localizedDescription)))
        }
    }

    func fetchMojombo(_ completion: EntireUserHandler) {
        guard let filePath = bundle.path(forResource: "sampleUserUrlMojombo",
                                         ofType: "json") else {
                                            fatalError("missing file in test: sampleUserUrlMojombo.json")
        }
        let url = URL(fileURLWithPath: filePath)
        do {
            let data = try Data(contentsOf: url)
            let user = try JSONDecoder().decode(EntireUser.self, from: data)
            completion(.success(user))
        } catch {
            completion(.failure(.badDecoder(error.localizedDescription)))
        }
    }
}

