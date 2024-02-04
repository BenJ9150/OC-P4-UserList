import Foundation

// MARK:  UserFetch Protocol

protocol UserFetch { // NEW_BL: Protocol to change fetchUsers method in unit test
    func fetchUsers(quantity: Int) async throws -> [User]
}

// MARK:  UserListRepository struct

struct UserListRepository: UserFetch { // NEW_BL: Add UserFetch protocol

    private let executeDataRequest: (URLRequest) async throws -> (Data, URLResponse)

    init(
        executeDataRequest: @escaping (URLRequest) async throws -> (Data, URLResponse) = URLSession.shared.data(for:)
    ) {
        self.executeDataRequest = executeDataRequest
    }

    func fetchUsers(quantity: Int) async throws -> [User] {
        guard let url = URL(string: "https://randomuser.me/api/") else {
            throw URLError(.badURL)
        }

        let request = try URLRequest(
            url: url,
            method: .GET,
            parameters: [
                "results": quantity
            ]
        )

        let (data, _) = try await executeDataRequest(request)

        // NEW_BL: new version of class UserListResponse contain only the User array named results
        // NEW_BL: So just return the results array
        let response = try JSONDecoder().decode(UserListResponse.self, from: data)
        return response.results
        //OLD:
        /*
        let response = try JSONDecoder().decode(UserListResponse.self, from: data)
        return response.results.map(User.init)
         */
    }
}
