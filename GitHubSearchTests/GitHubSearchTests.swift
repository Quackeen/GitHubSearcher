//
//  GitHubSearchTests.swift
//  GitHubSearch
//
//  Created by Joaquin Antonio Villegas on 5/11/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import XCTest
@testable import GitHubSearch

class GitHubSearchTests: XCTestCase {

    let service = MockService()

    func testCanFetchTomSearch() {
        // Arrange
        var users = [User]()

        // Act
        service.fetchTomSearch { (result) in
            if case Result.success(let toms) = result {
                users = toms
            }
        }

        // Assert
        XCTAssertFalse(users.isEmpty)
    }

    func testCanFetchMojomboRepos() {
        // Arrange
        var repos = [Repository]()


        // Act
        service.fetchMojomboRepos { (result) in
            if case Result.success(let mojomboRepos) = result {
                repos = mojomboRepos
            }
        }

        // Assert
        XCTAssertFalse(repos.isEmpty)
    }

    func testCanFetchMojombo() {
        // Arrange
        var user: EntireUser?

        // Act
        service.fetchMojombo { (result) in
            if case Result.success(let mojombo) = result {
                user = mojombo
            }
        }

        // Assert
        XCTAssertNotNil(user)
    }

}

