import SwiftUI

struct UserListView: View {
    // TODO: - Those properties should be viewModel's OutPuts
    @State private var isGridView = false // Ben: même celle là ??

    // NEW_BL: observed viewModel to respect MVVM pattern
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        NavigationView {
            if !isGridView {
                List(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        HStack {
                            // NEW_BL: use common struct to reduce code
                            UserImageView(user: user, imageSize: .thumbnail)
                            UserDescriptionView(user: user, withDate: true)
                        }
                    }
                    .onAppear {
                        if self.viewModel.shouldLoadMoreData(currentItem: user) {
                            self.viewModel.fetchUsers()
                        }
                    }
                }
                .navigationTitle("Users")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
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
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.viewModel.reloadUsers()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .imageScale(.large)
                        }
                    }
                }
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
                        ForEach(viewModel.users) { user in
                            NavigationLink(destination: UserDetailView(user: user)) {
                                VStack {
                                    UserImageView(user: user, imageSize: .medium) // NEWBEN
                                    UserDescriptionView(user: user, withDate: false) // NEWBEN
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
                .navigationTitle("Users")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
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
        }
        .onAppear {
            self.viewModel.fetchUsers()
        }
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView(viewModel: UserListViewModel())
    }
}
