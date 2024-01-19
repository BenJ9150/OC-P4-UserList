import Foundation

struct User: Identifiable, Codable { // NEWBEN: Codable
    let id = UUID() // NEWBEN: mis en constante
    let name: Name
    let dob: Dob
    let picture: Picture
    
    //NEWBEN:
    private enum CodingKeys: CodingKey { // to exclude id from decode
        case name, dob, picture
    }

    // MARK: - Init
    //NEWBEN: Mis en com
//    init(user: UserListResponse.User) {
//        self.name = .init(title: user.name.title, first: user.name.first, last: user.name.last)
//        self.dob = .init(date: user.dob.date, age: user.dob.age)
//        self.picture = .init(large: user.picture.large, medium: user.picture.medium, thumbnail: user.picture.thumbnail)
//    }

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
