import SwiftUI

struct UserListView: View {
    // NEW_BL: observed viewModel to respect MVVM pattern
    @StateObject private var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if !viewModel.isGridView {
                    List(viewModel.users) { user in
                        // NEW_BL: use common private struct to reduce code
                        UserRowView(viewModel: viewModel, user: user, lightDisplay: false)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                            ForEach(viewModel.users) { user in
                                // NEW_BL: use common private struct to reduce code
                                UserRowView(viewModel: viewModel, user: user, lightDisplay: true)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                // NEW_BL: use private func to reduce code
                userListToolbar()
            }
        }
        .onAppear {
            self.viewModel.fetchUsers()
        }
    }
}

// MARK: User Row

private extension UserListView {

    // NEW_BL: user row template for users list
    struct UserRowView: View {
        @ObservedObject var viewModel: UserListViewModel
        let user: User
        let lightDisplay: Bool

        var body: some View {
            NavigationLink(destination: UserDetailView(user: user)) {
                if lightDisplay {
                    VStack {
                        // NEW_BL: use common struct to reduce code
                        UserImageView(user: user, imageSize: .medium)
                        UserDescriptionView(user: user, withDate: false)
                    }
                } else {
                    HStack {
                        // NEW_BL: use common struct to reduce code
                        UserImageView(user: user, imageSize: .thumbnail)
                        UserDescriptionView(user: user, withDate: true)
                    }
                }
            }
            .onAppear {
                self.viewModel.shouldLoadMoreData(currentItem: user)
            }
        }
    }
}

// MARK: Toolbar

private extension UserListView {

    // NEW_BL: toolbar items of user list
    @ToolbarContentBuilder
    func userListToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Picker(selection: $viewModel.isGridView, label: Text("Display")) {
                Image(systemName: "rectangle.grid.1x2.fill")
                    .tag(true)
                    .accessibilityLabel(Text("Grid view"))
                Image(systemName: "list.bullet")
                    .tag(false)
                    .accessibilityLabel(Text("List view"))
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                self.viewModel.reloadUsers()
            }) {
                Image(systemName: "arrow.clockwise")
                    .imageScale(.large)
            }
        }
    }
}

// MARK: Preview

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
    }
}
