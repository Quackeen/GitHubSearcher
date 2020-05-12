//
//  UIKit+Fatal.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/11/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeue<Cell: UITableViewCell>(type: Cell.Type,
                                        reuseId: String,
                                        indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as? Cell else {
            fatalError("Attempted to dequeue cell of \(reuseId) before registering")
        }
        return cell
    }
}

extension UIStoryboard {
    func instantiate<VC: UIViewController>(_ type: VC.Type,
                                           identifier: String) -> VC {
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? VC else {
            fatalError("ViewController with identifier \(identifier) was not found on Storyboard")
        }
        return viewController
    }
}
