//  A2_iOS_Oleg_101466133

import SwiftUI
import CoreData

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.name, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<ProductEntity>

    var body: some View {
        NavigationStack {
            List {
                ForEach(products) { product in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(product.name ?? "No Name")
                            .font(.headline)

                        Text(product.productDescription ?? "No Description")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteProducts)
            }
            .navigationTitle("All Products")
        }
    }

    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Failed to delete product: \(error.localizedDescription)")
            }
        }
    }
}
