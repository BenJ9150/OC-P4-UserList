//
//  UserListViewModelTests.swift
//  UserListTests
//
//  Created by Benjamin LEFRANCOIS on 21/01/2024.
//

import XCTest
@testable import UserList

// NEW_BL: View Model test case

@MainActor // because users property of ViewModel is set on MainActor (published property)
final class UserListViewModelTests: XCTestCase {
    
    // MARK: Reload users
    
    func testReloadUsers() async {
        let exp = self.expectation(description: "Reload Users wait for queue change.")
        
        // Given users is loaded
        
        let setup = await getViewModelWithFakeUsers(nextExpectation: exp)
        let firstUserLoaded = setup.viewModel.users.first! // save first user to final test
        
        // When reload users

        setup.repository.users = fakeUsersReloaded // update mock users to reload different users
        setup.viewModel.reloadUsers()
        await fulfillment(of: [exp], timeout: 0.01)
        
        // Then first user has changed and count must be equal to 2 (2 reloaded users in mock)
        
        XCTAssertNotEqual(firstUserLoaded.id, setup.viewModel.users.first!.id)
        XCTAssertEqual(setup.viewModel.users.count, 2)
    }
    
    // MARK: Load more data
    
    func testLoadMoreData() async {
        let exp = self.expectation(description: "Load more Users wait for queue change.")
        
        // Given users is loaded
        
        let setup = await getViewModelWithFakeUsers(nextExpectation: exp)
        
        // When load more data
        
        setup.viewModel.shouldLoadMoreData(currentItem: setup.viewModel.users.last!)
        await fulfillment(of: [exp], timeout: 0.01)
        
        // Then users count must be equal to 6 (3 fetched users in mock)
        
        XCTAssertEqual(setup.viewModel.users.count, 6)
    }
}

// MARK: ViewModel with fake users

extension UserListViewModelTests {

    private func getViewModelWithFakeUsers(nextExpectation: XCTestExpectation) async ->
    (viewModel: UserListViewModel, repository: MockUserListRepository) {
        
        // Instantiate expectation for Fetch Users
        let exp = self.expectation(description: "Fetch Users wait for queue change.")
        
        // Instantiate MockUserListRepository
        let mockRepository = MockUserListRepository()
        mockRepository.bloc = { exp.fulfill() }
        
        // Instantiate ViewModel with mock
        let viewModel = UserListViewModel(repository: mockRepository)
        
        // fetch fake users
        viewModel.fetchUsers()
        await fulfillment(of: [exp], timeout: 0.01)
        
        // add next expectation for next test
        mockRepository.bloc = { nextExpectation.fulfill() }
        
        // return viewModel and mock repo
        return (viewModel, mockRepository)
    }
}
