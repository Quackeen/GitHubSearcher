//
//  GitHubService.swift
//  GitHubSearch
//
//  Created by Consultant on 5/10/20.
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

// TODO: Implement ServiceProvider to use cache
struct GitHubService {

    static let shared = GitHubService()

    private init() { }

    func getSearchUsers(isStubbing: Bool, searchTerm: String, completion: @escaping UserHandler) {

        // If isLocal() == false {
        if isStubbing {
            //let bundle = Bundle(for: AnyClass)
            guard let filePath = Bundle.main.path(forResource: "sampleSearchTom", ofType: "json") else {
                fatalError("missing file in test: sampleSearchTom.json")
            }
            let url = URL(fileURLWithPath: filePath)
            do {
                let data = try Data(contentsOf: url)
                let items = try JSONDecoder().decode(jsonItems.self, from: data)
                let users = items.items
                completion(.success(users))
            } catch {
                completion(.failure(.badDecoder(error.localizedDescription)))
            }
        } else {
            let url = GitHubAPI(searchTerm).searchURL!
            let request = URLRequest(url: url)
            // }

            // else do file path to json
            URLSession.shared.dataTask(with: request) { (dat, _, err) in

                if let error = err {
                    completion(.failure(.badDataTask(error.localizedDescription)))
                    return
                }

                if let data = dat {
                    do {
                        let items = try JSONDecoder().decode(jsonItems.self, from: data)
                        let users = items.items
                        completion(.success(users))
                    } catch {
                        completion(.failure(.badDecoder(error.localizedDescription)))
                    }
                }
            }.resume()
        }
    }

    func getEntireUser(isStubbing: Bool, user: User, completion: @escaping EntireUserHandler) {

        if isStubbing {
            guard let filePath = Bundle.main.path(forResource: "sampleUserUrlMojombo", ofType: "json") else {
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
        } else {
            let url = URL(string: user.url)!
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { (dat, _, err) in

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
    }

    func getUserRepositories(isStubbing: Bool, repoURL: String, completion: @escaping RepoHandler) {

        if isStubbing {
            guard let filePath = Bundle.main.path(forResource: "sampleRepoUrlMojombo", ofType: "json") else {
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
        } else {
            let url = URL(string: repoURL)
            let request = URLRequest(url: url!)

            URLSession.shared.dataTask(with: request) { (dat, _, err) in

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

}

