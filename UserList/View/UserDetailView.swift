import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack {
            UserDescriptionView(user: user, imageSize: .large, withDate: true)
            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}
