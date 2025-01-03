//
//  UserListViewModel.swift
//  UserList
//
//  Created by Benjamin LEFRANCOIS on 19/01/2024.
//

import SwiftUI

// NEW_BL: new class to create ViewModel

final class UserListViewModel: ObservableObject {
    
    // MARK: Private properties

    private let repository: UserFetch // NEW_BL: use UserFetch protocol instead of UserListRepository (for unit test)
    private var isLoading = false

    // MARK: Init
    
    init(repository: UserFetch = UserListRepository()) { // NEW_BL: add init for use custom repository in unit test
        self.repository = repository
    }

    // MARK: Outputs

    @Published var users: [User] = []
    @Published var isGridView = false

    // MARK: Inputs

    // NEW_BL: shouldLoadMoreData modified to directly integrate the fetchUsers call
    func shouldLoadMoreData(currentItem item: User) {
        guard let lastItem = users.last, !isLoading, item.id == lastItem.id else { return }
        fetchUsers()
    }
    // OLD
//    func shouldLoadMoreData(currentItem item: User) -> Bool {
//        guard let lastItem = users.last else { return false }
//        return !isLoading && item.id == lastItem.id
//    }

    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                await MainActor.run {
                    self.users.append(contentsOf: users)
                    self.isLoading = false
                }
            } catch {
                print("Error fetching users: \(error.localizedDescription)")
            }
        }
    }

    func reloadUsers() {
        users.removeAll()
        fetchUsers()
    }
}
