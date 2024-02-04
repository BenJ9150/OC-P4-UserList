//
//  MockUserListRepository.swift
//  UserListTests
//
//  Created by Benjamin LEFRANCOIS on 04/02/2024.
//

import Foundation
@testable import UserList

final class MockUserListRepository: UserFetch {
    
    var bloc: (() -> Void)?
    var users = fakeUsers
    
    func fetchUsers(quantity: Int) async throws -> [User] {
        defer {
            bloc?()
        }
        return users
    }
}

// MARK: Fake users

let fakeUsers = [
    User(name: User.Name(title: "test", first: "test", last: "test"),
         dob: User.Dob(date: "test", age: 10),
         picture: User.Picture(large: "test", medium: "test", thumbnail: "test")),
    
    User(name: User.Name(title: "test", first: "test", last: "test"),
         dob: User.Dob(date: "test", age: 10),
         picture: User.Picture(large: "test", medium: "test", thumbnail: "test")),
    
    User(name: User.Name(title: "test", first: "test", last: "test"),
         dob: User.Dob(date: "test", age: 10),
         picture: User.Picture(large: "test", medium: "test", thumbnail: "test"))
]

let fakeUsersReloaded = [
    User(name: User.Name(title: "testReload", first: "testReload", last: "testReload"),
         dob: User.Dob(date: "testReload", age: 10),
         picture: User.Picture(large: "testReload", medium: "testReload", thumbnail: "testReload")),
    
    User(name: User.Name(title: "testReload", first: "testReload", last: "testReload"),
         dob: User.Dob(date: "testReload", age: 10),
         picture: User.Picture(large: "testReload", medium: "testReload", thumbnail: "testReload"))
]
