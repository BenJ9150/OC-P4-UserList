import SwiftUI

struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack {
            // NEW_BL: use common struct to reduce code
            UserImageView(user: user, imageSize: .large)
            UserDescriptionView(user: user, withDate: true)
                .padding()
            Spacer()
        }
        .navigationTitle("\(user.name.first) \(user.name.last)")
    }
}
