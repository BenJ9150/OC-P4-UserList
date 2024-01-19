//
//  UserListViewModel.swift
//  UserList
//
//  Created by Benjamin LEFRANCOIS on 19/01/2024.
//

import SwiftUI

final class UserListViewModel: ObservableObject {

    // MARK: - Private properties

    private let repository = UserListRepository()
    private var isLoading = false

    // MARK: - Outputs

    @Published var users: [User] = []

    // TODO: - Should be an OutPut
    func shouldLoadMoreData(currentItem item: User) -> Bool {
        guard let lastItem = users.last else { return false }
        return !isLoading && item.id == lastItem.id
    }

    // MARK: - Inputs

    func fetchUsers() {
        isLoading = true
        Task {
            do {
                let users = try await repository.fetchUsers(quantity: 20)
                DispatchQueue.main.async {
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
