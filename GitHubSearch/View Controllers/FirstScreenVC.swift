//
//  FirstScreenVC.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  Initial view controller with a search bar that will search GitHub users and display them on the table view

import Foundation
import UIKit

class FirstScreenVC: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView! // Used to display users in UserTableCell's

    let searchController = UISearchController(searchResultsController: nil) // Search controller for GitHub

    let viewModel = GitHubViewModel() // Instance of the GitHubViewModel

    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.delegate = self
        usersTableView.register(UINib(nibName: UserTableCell.identifier,bundle: Bundle.main),
                                forCellReuseIdentifier: UserTableCell.identifier)
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}

extension FirstScreenVC: UITableViewDelegate, UITableViewDataSource {
    // Return the number in the searchResults array of found users
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }

    // Returns cells that represent users and setting UI elements
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableCell.identifier, for: indexPath) as! UserTableCell
        let user = viewModel.searchResults[indexPath.row]
        for entireUser in viewModel.entireUsers {
            if entireUser.url == user.url {
                let detailedUser = entireUser
                cell.repoLabel.text = "Repos: " + String(detailedUser.public_repos!)
            }
        }
        cell.user = user
        cell.usernameLabel.text = user.login
        return cell
    }

    // Handle navigating to next view when a cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondVC = storyboard?.instantiateViewController(withIdentifier: "SecondScreenVC") as! SecondScreenVC
        let user = viewModel.searchResults[indexPath.row]

        for entireUser in viewModel.entireUsers {
            if entireUser.url == user.url {
                let detailedUser = entireUser
                secondVC.entireUser = detailedUser
                viewModel.getRepositories(user: detailedUser)
            }
        }
        secondVC.user = user
        secondVC.viewModel = viewModel
        navigationController?.pushViewController(secondVC, animated: true)
    }

    // Use automaticDimention for the height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FirstScreenVC: UISearchBarDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {

    }

    // Search for users as the search bar text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let search = searchBar.text,
            let sanitized = search.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        if !searchBar.text!.isEmpty {
            viewModel.getSearchResults(searchTerm: sanitized)
            usersTableView.reloadData()
        }
    }
}

// Conform to delegate protocols
extension FirstScreenVC: RepositoriesDelegate, SearchResultsDelegate {
    func update() {
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
    }
}
