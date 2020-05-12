//
//  GitHubUserViewModel.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/11/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  View model to handle all service calls and data binding for a single user & his/her repos

import Foundation

class GitHubUserViewModel {

    private let user: EntireUser
    private var update: (()->Void)?

    // Array of all Repository, prior to filtering
    private var allRepos = [Repository]() {
        didSet {
            repositoriesResults = allRepos
        }
    }

    // Array of Repository's to hold user repositories for detail view
    private var repositoriesResults = [Repository]() {
        didSet {
            update?()
        }
    }

    init(_ user: EntireUser) {
        self.user = user
    }

    func bind(_ update: @escaping ()->Void) {
        self.update = update
    }

    func unbind() {
        self.update = nil
    }

}

// User's GitHub details
extension GitHubUserViewModel {

    var repoCount: Int {
        return repositoriesResults.count
    }

    var imageUrl: URL? {
        let picUrl = user.avatarUrl
        return URL(string: picUrl)
    }

    var email: String? {
        return user.email
    }

    var location: String? {
        return user.location
    }

    var joinDate: String {
        return user.created
    }

    var name: String {
        return user.login
    }

    var bio: String? {
        return user.bio
    }

    var followers: String {
        return String(user.followers) + " Followers"
    }

    var following: String {
        return "Following " + String(user.following)
    }
}

// User's Repos information
extension GitHubUserViewModel {

    func repoName(_ index: Int) -> String {
        return repositoriesResults[index].name
    }

    func repoForks(_ index: Int) -> String {
        let repo = repositoriesResults[index]
        return String(repo.forks) + " Forks"
    }

    func repoStargazers(_ index: Int) -> String {
        let repo = repositoriesResults[index]
        return String(repo.stargazers) + " Stars"
    }

    func repoUrl(_ index: Int) -> URL? {
        let repo = repositoriesResults[index]
        return URL(string: repo.url)
    }

    // Function to make service call to get repository information
    func getRepositories() {
        // Calls on service class method to make a network call if isStubbing is false or use sample JSON info if
        // isStubbing is true to avoid GitHub's rate limit
        service.getUserRepositories(repoURL: user.reposUrl) { [weak self] result in
            switch result {
                case .success(let repos):
                    self?.allRepos = repos
                case .failure(let error):
                    print("GitHub Error: \(error.localizedDescription)")
            }
        }
    }

    func filter(with searchTerm: String) {
        // Show everything if user clears search
        if searchTerm.isEmpty {
            repositoriesResults = allRepos
            return
        }
        // Show filtered results
        let term = searchTerm.lowercased()
        let filtered = allRepos.filter { $0.name.lowercased().contains(term) }
        repositoriesResults = filtered
    }
}
