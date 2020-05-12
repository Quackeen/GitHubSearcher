//
//  GitHubService.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/10/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

enum GitHubError: Error {
    case badURL(String)
    case badDataTask(String)
    case badDecoder(String)
}

typealias UserHandler = (Result<[User], GitHubError>) -> Void
typealias EntireUserHandler = (Result<EntireUser, GitHubError>) -> Void
typealias RepoHandler = (Result<[Repository], GitHubError>) -> Void

let service = GitHubService.shared

struct GitHubService {

    static let shared = GitHubService()
    let session: URLSession = URLSession(configuration: .default)

    private init() { }

    func getSearchUsers(searchTerm: String, completion: @escaping UserHandler) {

        let url = GitHubAPI(searchTerm).searchURL!
        let request = URLRequest(url: url)
        // }

        // else do file path to json
        session.dataTask(with: request) { (dat, _, err) in

            if let error = err {
                completion(.failure(.badDataTask(error.localizedDescription)))
                return
            }

            if let data = dat {
                do {
                    let items = try JSONDecoder().decode(JsonItems.self, from: data)
                    let users = items.items
                    completion(.success(users))
                } catch {
                    completion(.failure(.badDecoder(error.localizedDescription)))
                }
            }
        }.resume()
    }

    func getEntireUser(user: User, completion: @escaping EntireUserHandler) {
        let url = URL(string: user.url)!
        let request = URLRequest(url: url)

        session.dataTask(with: request) { (dat, _, err) in

            if let error = err {
                completion(.failure(.badDataTask(error.localizedDescription)))
                return
            }

            if let data = dat {
                do {
                    let user = try JSONDecoder().decode(EntireUser.self, from: data)
                    completion(.success(user))
                } catch {
                    completion(.failure(.badDecoder(error.localizedDescription)))
                }
            }
        }.resume()
    }

    func getUserRepositories(repoURL: String, completion: @escaping RepoHandler) {
        let url = URL(string: repoURL)
        let request = URLRequest(url: url!)

        session.dataTask(with: request) { (dat, _, err) in

            if let error = err {
                completion(.failure(.badDataTask(error.localizedDescription)))
                return
            }

            if let data = dat {
                do {
                    let repos = try JSONDecoder().decode([Repository].self, from: data)
                    completion(.success(repos))
                } catch {
                    completion(.failure(.badDecoder(error.localizedDescription)))
                }
            }
        }.resume()
    }

}
