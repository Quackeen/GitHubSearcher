//
//  UserTableCell.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/08/20.
//  Copyright © 2020 MAC. All rights reserved.
//
//  Reusable Table View Cell to represent users in initial table view

import UIKit

class UserTableCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView! // Used to represent user profile image

    @IBOutlet weak var repoLabel: UILabel! // Used to represent user number of repositories

    @IBOutlet weak var usernameLabel: UILabel! // Used to represent user username

    static let identifier = "UserTableCell" // Identifier for cell

    // Property observer that fetches image from cache/network when user is identified
    var user: User? {
        didSet {
            guard let picUrl = user?.avatar_url else {
                userImageView.image = nil
                return
            }
            ImagesService.shared.fetch(from: picUrl) { image in
                self.userImageView.image = image
            }
        }
    }
    
}
