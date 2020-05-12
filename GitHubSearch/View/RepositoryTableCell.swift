//
//  RepositoryTableCell.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  Reusable table view cell to represent individual repositories in the detailed user view

import UIKit

class RepositoryTableCell: UITableViewCell {

    @IBOutlet weak var repoNameLabel: UILabel! // Used to represent repository name
    @IBOutlet weak var forksLabel: UILabel! // Used to represent number of forks
    @IBOutlet weak var starsLabel: UILabel! // Used to represent number of stars

    static let identifier = "RepositoryTableCell" // Identifier for cell

}
