//  A2_iOS_Oleg_101466133

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }

            AddProductView()
                .tabItem {
                    Label("Add", systemImage: "plus.circle")
                }

            ProductListView()
                .tabItem {
                    Label("Products", systemImage: "list.bullet")
                }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
