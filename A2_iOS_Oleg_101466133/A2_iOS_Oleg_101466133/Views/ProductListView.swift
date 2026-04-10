//  A2_iOS_Oleg_101466133

import SwiftUI
import CoreData

struct ProductListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.productID, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<ProductEntity>

    @State private var productToDelete: ProductEntity?
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            Group {
                if products.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()

                        Image(systemName: "shippingbox")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)

                        Text("No products available")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("Add a new product to see it here.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        ForEach(products) { product in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(product.name ?? "No Name")
                                    .font(.headline)

                                Text(product.productDescription ?? "No Description")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("ID: \(product.productID ?? "")")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Text(String(format: "$%.2f", product.price))
                                    .font(.caption)

                                Text("Provider: \(product.provider ?? "")")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    productToDelete = product
                                    showDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("All Products")
            .alert("Delete Product", isPresented: $showDeleteAlert, presenting: productToDelete) { product in
                Button("Delete", role: .destructive) {
                    delete(product)
                }

                Button("Cancel", role: .cancel) { }
            } message: { product in
                Text("Are you sure you want to delete \(product.name ?? "this product")?")
            }
        }
    }

    private func delete(_ product: ProductEntity) {
        viewContext.delete(product)

        do {
            try viewContext.save()
        } catch {
            print("Failed to delete product: \(error.localizedDescription)")
        }
    }
}
