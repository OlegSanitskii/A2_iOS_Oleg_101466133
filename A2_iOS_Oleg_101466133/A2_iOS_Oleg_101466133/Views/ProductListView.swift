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
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(products) { product in
                                productCard(for: product)
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
                        .padding()
                    }
                    .background(Color(.systemGroupedBackground))
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

    @ViewBuilder
    private func productCard(for product: ProductEntity) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.12))
                    .frame(width: 52, height: 52)

                Image(systemName: "cube.box.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(product.name ?? "No Name")
                    .font(.headline)

                Text(product.productDescription ?? "No Description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    Text(product.productID ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Text(String(format: "$%.2f", product.price))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Text("Provider: \(product.provider ?? "")")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
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
