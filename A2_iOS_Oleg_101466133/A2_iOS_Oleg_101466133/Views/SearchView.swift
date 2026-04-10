//  A2_iOS_Oleg_101466133


import SwiftUI
import CoreData

struct SearchView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.productID, ascending: true)],
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
            Group {
                if filteredProducts.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()

                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 46))
                            .foregroundColor(.gray)

                        Text("No matching products found")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("Try searching with a different product name or description.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        ForEach(filteredProducts) { product in
                            searchCard(for: product)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGroupedBackground))
                }
            }
            .navigationTitle("Search Products")
            .searchable(text: $searchText, prompt: "Search by name or description")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("\(filteredProducts.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    @ViewBuilder
    private func searchCard(for product: ProductEntity) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.12))
                    .frame(width: 52, height: 52)

                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.title3)
                    .foregroundColor(.green)
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
}
