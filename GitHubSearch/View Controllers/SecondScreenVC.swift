//
//  SecondScreenVC.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  Detailed view with user information as well as their repositories in a table view

import Foundation
import UIKit

class SecondScreenVC: UIViewController {

    @IBOutlet weak var repositoryTableView: UITableView! // Used to hold repository cells
    @IBOutlet weak var avatarImageView: UIImageView! // Used to represent user profile image
    @IBOutlet weak var usernameLabel: UILabel! // Used to represent user username
    @IBOutlet weak var emailLabel: UILabel! // Used to represent user email
    @IBOutlet weak var locationLabel: UILabel! // Used to represent user location
    @IBOutlet weak var joinDateLabel: UILabel! // Used to represent user join date
    @IBOutlet weak var followersLabel: UILabel! // Used to represent user followers
    @IBOutlet weak var followingLabel: UILabel! // Used to represent user followings
    @IBOutlet weak var biographyLabel: UILabel! // Used to represent user biography
    @IBOutlet weak var repositorySearchBar: UISearchBar! // Used to filter through the user repositories

    var user: User? // Instance of User to represent user
    var viewModel = GitHubViewModel() // Instance of viewModel

    // Instance of EntireUser to represent user, as well as retreive image from cache or network if unavailable
    var entireUser: EntireUser? {
        didSet {
            guard let picUrl = self.entireUser?.avatar_url else {
                avatarImageView.image = nil
                return
            }
            ImagesService.shared.fetch(from: picUrl) { image in
                self.avatarImageView.image = image
            }
        }
    }

    // Array of Repository's that will be used to filter by searching
    var filteredRepos = [Repository]()


    override func viewDidLoad() {
        super.viewDidLoad()
        repositoryTableView.delegate = self
        repositorySearchBar.delegate = self
        repositoryTableView.register(UINib(nibName: RepositoryTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: RepositoryTableCell.identifier)
        setupUI()
    }

    // Helper function to setup UI
    private func setupUI() {
        emailLabel.text = entireUser?.email
        locationLabel.text = entireUser?.location
        joinDateLabel.text = entireUser?.created_at
        usernameLabel.text = entireUser?.login
        biographyLabel.text = entireUser?.bio
        if let unwrappedFollowers = entireUser?.followers {
            followersLabel.text = String(unwrappedFollowers) + " Followers"
        } else {
            followersLabel.text = String(0) + " Followers"
        }

        if let unwrappedFollowing = entireUser?.following {
            followingLabel.text = "Following " + String(unwrappedFollowing)
        } else {
            followingLabel.text = "Following " + String(0)
        }
    }

    // Function to filter results of Repository's to make a filtered list by searching
    private func filter(with search: String) {
        filteredRepos = viewModel.repositoriesResults.filter({$0.name.lowercased().contains(search.lowercased())})
        repositoryTableView.reloadData()
    }

}

extension SecondScreenVC: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    // Use filteredRepos if we have filtered; otherwise return the entire list
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredRepos.count != 0 {
            return filteredRepos.count
        } else {
            return viewModel.repositoriesResults.count
        }
    }

    // Create cells from either filteredRepos or entire list and update UI accordingly
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredRepos.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableCell.identifier, for: indexPath) as! RepositoryTableCell
            let repo = filteredRepos[indexPath.row]
            cell.repoNameLabel.text = repo.name
            cell.forksLabel.text = String(repo.forks_count) + " Forks"
            cell.starsLabel.text = String(repo.stargazers_count) + " Stars"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: RepositoryTableCell.identifier, for: indexPath) as! RepositoryTableCell
            let repo = viewModel.repositoriesResults[indexPath.row]
            cell.repoNameLabel.text = repo.name
            cell.forksLabel.text = String(repo.forks_count) + " Forks"
            cell.starsLabel.text = String(repo.stargazers_count) + " Stars"
            return cell
        }
    }

    // Open the url for the corresponding repository when clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let repo = viewModel.repositoriesResults[indexPath.row]
        if let url = URL(string: repo.html_url) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }

    // Handle filtering repository list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(with: searchBar.text ?? "")
        repositoryTableView.reloadData()
    }
}
