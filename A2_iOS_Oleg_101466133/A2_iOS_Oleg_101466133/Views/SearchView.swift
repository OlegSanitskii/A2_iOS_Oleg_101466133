//  A2_iOS_Oleg_101466133


import SwiftUI
import CoreData

struct SearchView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.name, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<ProductEntity>

    @State private var searchText = ""

    var filteredProducts: [ProductEntity] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return Array(products)
        }

        return products.filter { product in
            let nameMatch = product.name?.localizedCaseInsensitiveContains(searchText) ?? false
            let descriptionMatch = product.productDescription?.localizedCaseInsensitiveContains(searchText) ?? false
            return nameMatch || descriptionMatch
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search by name or description", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                List(filteredProducts) { product in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(product.name ?? "No Name")
                            .font(.headline)

                        Text(product.productDescription ?? "No Description")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text(String(format: "$%.2f", product.price))
                            .font(.subheadline)

                        Text("Provider: \(product.provider ?? "")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Search Products")
        }
    }
}
