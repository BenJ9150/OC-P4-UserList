import SwiftUI

struct UserListView: View {
    // TODO: - Those properties should be viewModel's OutPuts
    @State private var isGridView = false // Ben: même celle là ??

    // NEWBEN : observed viewModel to respect MVVM pattern
    @ObservedObject var viewModel: UserListViewModel
    
    var body: some View {
        NavigationView {
            if !isGridView {
                List(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user)) {
                        HStack {
                            UserDescriptionView(user: user, imageSize: .thumbnail, withDate: true) // NEWBEN
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
                                    UserDescriptionView(user: user, imageSize: .medium, withDate: false) // NEWBEN
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
