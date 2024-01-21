//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Benjamin LEFRANCOIS on 21/01/2024.
//

import XCTest
@testable import UserList

// NEW_BL: View Model test case
final class UserListViewModelTests: XCTestCase {

    func testReloadUsers() {
        // Given users is loaded
        let viewModel = UserListViewModel()
        viewModel.fetchUsers()
        waitExpectation(name: "FetchUsers")
        let firstUserLoaded = viewModel.users.first!

        // When reload users
        viewModel.reloadUsers()
        waitExpectation(name: "ReloadUsers")
        
        // Then users have changed
        XCTAssertNotEqual(firstUserLoaded.id, viewModel.users.first!.id)
        XCTAssertEqual(viewModel.users.count, viewModel.fetchUsersQty)
    }

    func testLoadMoreData() {
        // Given users is loaded
        let viewModel = UserListViewModel()
        viewModel.fetchUsers()
        waitExpectation(name: "FetchUsers")

        // When load more data
        viewModel.shouldLoadMoreData(currentItem: viewModel.users.last!)
        waitExpectation(name: "ShouldLoadMoreData")
        
        // Then users count up
        XCTAssertEqual(viewModel.users.count, viewModel.fetchUsersQty * 2)
    }
}

extension UserListViewModelTests {

    private func waitExpectation(name: String) {
        let expectation = XCTestExpectation(description: name)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
