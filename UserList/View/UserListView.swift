import SwiftUI

struct UserListView: View {
    // TODO: - Those properties should be viewModel's OutPuts
    @State private var isGridView = false // Ben: même celle là ??

    // NEW_BL: observed viewModel to respect MVVM pattern
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if !isGridView {
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    // NEW_BL: use private var reduce code
                    toolbarPicker
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    // NEW_BL: use private var reduce code
                    toolbarRefreshButton
                }
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
                if self.viewModel.shouldLoadMoreData(currentItem: user) {
                    self.viewModel.fetchUsers()
                }
            }
        }
    }
}

// MARK: Toolbar items

private extension UserListView {

    // NEW_BL: picker of toolbar property
    var toolbarPicker: some View {
        Picker(selection: $isGridView, label: Text("Display")) {
            Image(systemName: "rectangle.grid.1x2.fill")
                .tag(true)
                .accessibilityLabel(Text("Grid view"))
            Image(systemName: "list.bullet")
                .tag(false)
                .accessibilityLabel(Text("List view"))
        }
        .pickerStyle(SegmentedPickerStyle())
    }

    // NEW_BL: refresh button of toolbar property
    var toolbarRefreshButton: some View {
        Button(action: {
            self.viewModel.reloadUsers()
        }) {
            Image(systemName: "arrow.clockwise")
                .imageScale(.large)
        }
    }
}

// MARK: Preview

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: UserListViewModel())
    }
}
