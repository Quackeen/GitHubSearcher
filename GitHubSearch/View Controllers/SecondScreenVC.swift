//
//  SecondScreenVC.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  Detailed view with user information as well as their repositories in a table view

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

    var viewModel: GitHubUserViewModel! { // Instance of viewModel
        didSet {
            self.viewModel?.bind {
                DispatchQueue.main.async {
                    self.repositoryTableView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard viewModel != nil else {
            fatalError("Entered SecondScreenVC without ViewModel")
        }
        setupTable()
        setupUI()
    }

    deinit {
        viewModel?.unbind()
    }

    // Helper function to setup Table
    private func setupTable() {
        repositoryTableView.delegate = self
        repositorySearchBar.delegate = self
        let nib = UINib(nibName: RepositoryTableCell.identifier,
                        bundle: Bundle.main)
        repositoryTableView.register(nib,
                                     forCellReuseIdentifier: RepositoryTableCell.identifier)
    }

    // Helper function to setup UI
    private func setupUI() {
        viewModel.getRepositories()
        if let picUrl = viewModel.imageUrl {
            ImagesService.shared.fetch(from: picUrl) { image in
                self.avatarImageView.image = image
            }
        } else {
            avatarImageView.image = nil
        }
        emailLabel.text = viewModel.email
        locationLabel.text = viewModel.location
        joinDateLabel.text = viewModel.joinDate
        usernameLabel.text = viewModel.name
        biographyLabel.text = viewModel.bio
        followersLabel.text = viewModel.followers
        followingLabel.text = viewModel.following
    }
}

extension SecondScreenVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.repoCount
    }

    // Create cells and update UI accordingly
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(type: RepositoryTableCell.self,
                                     reuseId: RepositoryTableCell.identifier, indexPath: indexPath)
        let index = indexPath.row
        cell.repoNameLabel.text = viewModel.repoName(index)
        cell.forksLabel.text = viewModel.repoForks(index)
        cell.starsLabel.text = viewModel.repoStargazers(index)
        return cell
    }

    // Open the url for the corresponding repository when clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = viewModel.repoUrl(indexPath.row), UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:])
    }
}

extension SecondScreenVC: UISearchBarDelegate {
    // Handle filtering repository list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(with: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        viewModel.filter(with: searchText)
    }
}
