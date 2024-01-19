import Foundation

// NEW_BL: User is codable for Json Decoder
struct User: Identifiable, Codable {
    let id = UUID()
    let name: Name
    let dob: Dob
    let picture: Picture
    
    // NEW_BL: to exclude id from decode
    private enum CodingKeys: CodingKey {
        case name, dob, picture
    }

    // MARK: - Dob
    struct Dob: Codable {
        let date: String
        let age: Int
    }

    // MARK: - Name
    struct Name: Codable {
        let title, first, last: String
    }

    // MARK: - Picture
    struct Picture: Codable {
        let large, medium, thumbnail: String
    }
}

// OLD
/*
struct User: Identifiable {
    var id = UUID()
    let name: Name
    let dob: Dob
    let picture: Picture

    // MARK: - Init
    init(user: UserListResponse.User) {
        self.name = .init(title: user.name.title, first: user.name.first, last: user.name.last)
        self.dob = .init(date: user.dob.date, age: user.dob.age)
        self.picture = .init(large: user.picture.large, medium: user.picture.medium, thumbnail: user.picture.thumbnail)
    }

    // MARK: - Dob
    struct Dob: Codable {
        let date: String
        let age: Int
    }

    // MARK: - Name
    struct Name: Codable {
        let title, first, last: String
    }

    // MARK: - Picture
    struct Picture: Codable {
        let large, medium, thumbnail: String
    }
}
*/
