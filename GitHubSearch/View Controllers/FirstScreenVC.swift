//
//  FirstScreenVC.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  Initial view controller with a search bar that will search GitHub users and display them on the table view

import UIKit

class FirstScreenVC: UIViewController {

    @IBOutlet weak var usersTableView: UITableView! // Used to display users in UserTableCell's

    let searchController = UISearchController(searchResultsController: nil) // Search controller for GitHub

    let viewModel = GitHubViewModel() // Instance of the GitHubViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.delegate = self
        let nib = UINib(nibName: UserTableCell.identifier, bundle: Bundle.main)
        usersTableView.register(nib,
                                forCellReuseIdentifier: UserTableCell.identifier)
        usersTableView.rowHeight = UITableView.automaticDimension
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        viewModel.bind {
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
            }
        }
    }

    deinit {
        viewModel.unbind()
    }
}

extension FirstScreenVC: UITableViewDelegate, UITableViewDataSource {
    // Return the number in the searchResults array of found users
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResultsCount
    }

    // Returns cells that represent users and setting UI elements
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(type: UserTableCell.self, reuseId: UserTableCell.identifier, indexPath: indexPath)
        let index = indexPath.row
        cell.usernameLabel.text = viewModel.name(index)
        cell.repoLabel.text = viewModel.repoCount(index)

        if let picUrl = viewModel.imageUrl(index) {
            ImagesService.shared.fetch(from: picUrl) { image in
                cell.userImageView.image = image
            }
        } else {
            cell.userImageView.image = nil
        }

        return cell
    }

    // Handle navigating to next view when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = "SecondScreenVC"
        guard let secondVC = storyboard?.instantiate(SecondScreenVC.self,
                                                     identifier: identifier) else {
            return
        }
        // Make a ViewModel for the Selected User
        secondVC.viewModel = viewModel.makeGitHubUserViewModel(index: indexPath.row)
        navigationController?.pushViewController(secondVC, animated: true)
    }
}

extension FirstScreenVC: UISearchBarDelegate {

    // Search for users as the search bar text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.getSearchResults(searchTerm: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text else { return }
        viewModel.getSearchResults(searchTerm: search)
    }
}
