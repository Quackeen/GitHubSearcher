//
//  GitHubViewModel.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  View model to handle all service calls and data binding

import Foundation

// Delegate for the ViewModel to have an update method that will reload the search results in a UITableView's data
protocol SearchResultsDelegate: class {
    func update()
}

// Delegate for the ViewModel to have an update method that will reload the EntireUser data
protocol EntireUserDelegate: class {
    func update()
}

// Delegate for the ViewModel to have an update method that will reload the repository results in a UITableView's data
protocol RepositoriesDelegate: class {
    func update()
}

public class GitHubViewModel {

    // Create delegates
    weak var searchResultsDelegate: SearchResultsDelegate?
    weak var entireUserDelegate: EntireUserDelegate?
    weak var repositoriesDelegate: RepositoriesDelegate?

    // Array of Users that will call to get the entire information when set
    var searchResults = [User]() {
        didSet {
            searchResultsDelegate?.update()
            for user in self.searchResults {
                getEntireUser(user: user)
            }
        }
    }

    // Array of EntireUsers to hold the entire information of the users found
    var entireUsers = [EntireUser]() {
        didSet {
            entireUserDelegate?.update()
        }
    }

    // Array of Repository's to hold user repositories for detail view
    var repositoriesResults = [Repository]() {
        didSet {
            repositoriesDelegate?.update()
        }
    }
}

public extension GitHubViewModel {

    // Function to make service call to get search results
    func getSearchResults(searchTerm: String) {
        // Calls on service class method to make a network call if isStubbing is false or use sample JSON info if
        // isStubbing is true to avoid GitHub's rate limit
        service.getSearchUsers(isStubbing: true, searchTerm: searchTerm) { [weak self] GitHubResult in
            switch GitHubResult {
            case .success(let results):
                self?.searchResults = results
            case .failure(let error):
                print("GitHub Error: \(error.localizedDescription)")
            }
        }
    }

    // Function to make service call to get full information of Users
    internal func getEntireUser(user: User) {
        // Calls on service class method to make a network call if isStubbing is false or use sample JSON info if
        // isStubbing is true to avoid GitHub's rate limit
        service.getEntireUser(isStubbing: true, user: user) { [weak self] GitHubResult in
            switch GitHubResult {
            case .success(let results):
                self?.entireUsers.append(results)
            case .failure(let error):
                print("GitHub Error: \(error.localizedDescription)")
            }
        }
    }

    // Function to make service call to get repository information
    internal func getRepositories(user: EntireUser) {
        // Calls on service class method to make a network call if isStubbing is false or use sample JSON info if
        // isStubbing is true to avoid GitHub's rate limit
        service.getUserRepositories(isStubbing: true, repoURL: user.repos_url) { [weak self] GitHubResult in
            switch GitHubResult {
            case .success(let repos):
                self?.repositoriesResults = repos
            case .failure(let error):
                print("GitHub Error: \(error.localizedDescription)")
            }
        }

    }
}
