//
//  GitHubViewModel.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  View model to handle all service calls and data binding

import Foundation

class GitHubViewModel {

    // Array of EntireUsers to hold the entire information of the users found
    private var users = [EntireUser]() {
        didSet {
            update?()
        }
    }
    private var update: (()->Void)?
    private var currentSearch: DispatchWorkItem?

    func bind(_ update: @escaping ()->Void) {
        self.update = update
    }

    func unbind() {
        self.update = nil
    }
}

extension GitHubViewModel {

    // Function to make service call to get search results
    func getSearchResults(searchTerm: String) {
        // Calls on service class method to make a network call
        guard !searchTerm.isEmpty,
            let sanitized = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                return
        }
        currentSearch?.cancel()

        let search = DispatchWorkItem(block: { [weak self] in
            self?.users = []
            service.getSearchUsers(searchTerm: sanitized) { [weak self] result in
                switch result {
                    case .success(let results):
                        for user in results {
                            self?.getEntireUser(user: user)
                        }
                    case .failure(let error):
                        print("GitHub Error: \(error.localizedDescription)")
                }
            }
        })

        currentSearch = search
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.45,
                                                       execute: search)
    }

    // Function to make service call to get full information of Users
    func getEntireUser(user: User) {
        service.getEntireUser(user: user) { [weak self] result in
            switch result {
                case .success(let results):
                    self?.users.append(results)
                case .failure(let error):
                    print("GitHub Error: \(error.localizedDescription)")
            }
        }
    }
}

// Accessors for all User info
extension GitHubViewModel {

    var searchResultsCount: Int {
        return users.count
    }

    func name(_ index: Int) -> String {
        return users[index].login
    }

    func repoCount(_ index: Int) -> String {
        let user = users[index]
        return "Repos: " + String(user.publicRepoCount)
    }

    func imageUrl(_ index: Int) -> URL? {
        let picUrl = users[index].avatarUrl
        return URL(string: picUrl)
    }

    // Function to make ViewModel for a Single User's Repos
    func makeGitHubUserViewModel(index: Int) -> GitHubUserViewModel {
        let user = users[index]
        return GitHubUserViewModel(user)
    }

}

