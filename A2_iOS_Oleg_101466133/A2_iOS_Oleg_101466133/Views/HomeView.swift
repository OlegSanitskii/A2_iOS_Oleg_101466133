//  A2_iOS_Oleg_101466133


import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ProductEntity.productID, ascending: true)],
        animation: .default
    )
    private var products: FetchedResults<ProductEntity>

    @State private var currentIndex: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Oleg Sanitskii - 101466133")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if products.isEmpty {
                    Spacer()

                    Text("No products found")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Tap the button below to load the sample products.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button("Load Sample Products") {
                        seedProductsIfNeeded()
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()
                } else {
                    let product = products[currentIndex]

                    VStack(alignment: .leading, spacing: 12) {
                        Text(product.name ?? "No Name")
                            .font(.title)
                            .fontWeight(.bold)

                        Text("Product ID: \(product.productID ?? "")")
                        Text("Description: \(product.productDescription ?? "")")
                        Text(String(format: "Price: $%.2f", product.price))
                        Text("Provider: \(product.provider ?? "")")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                    .padding(.horizontal)

                    Text("Product \(currentIndex + 1) of \(products.count)")
                        .foregroundColor(.secondary)

                    HStack(spacing: 20) {
                        Button {
                            if currentIndex > 0 {
                                currentIndex -= 1
                            }
                        } label: {
                            Label("Previous", systemImage: "chevron.left")
                        }
                        .buttonStyle(.bordered)
                        .disabled(currentIndex == 0)

                        Button {
                            if currentIndex < products.count - 1 {
                                currentIndex += 1
                            }
                        } label: {
                            Label("Next", systemImage: "chevron.right")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(currentIndex == products.count - 1)
                    }

                    Spacer()
                }
            }
            .padding()
            .navigationTitle("First Product")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reset") {
                        resetSampleProducts()
                    }
                }
            }
            .onAppear {
                seedProductsIfNeeded()

                if !products.isEmpty {
                    currentIndex = min(currentIndex, max(products.count - 1, 0))
                }
            }
            .onChange(of: products.count) { _, newCount in
                if newCount == 0 {
                    currentIndex = 0
                } else if currentIndex >= newCount {
                    currentIndex = newCount - 1
                }
            }
        }
    }

    private func seedProductsIfNeeded() {
        if !products.isEmpty { return }

        let sampleProducts: [(String, String, String, Double, String)] = [
            ("P001", "iPhone 15", "Apple smartphone with dynamic island", 999.99, "Apple"),
            ("P002", "MacBook Air", "Lightweight laptop with M-series chip", 1299.99, "Apple"),
            ("P003", "iPad Pro", "Tablet for productivity and design", 1099.99, "Apple"),
            ("P004", "AirPods Pro", "Wireless earbuds with noise cancellation", 329.99, "Apple"),
            ("P005", "Galaxy S24", "Samsung flagship smartphone", 949.99, "Samsung"),
            ("P006", "Galaxy Tab", "Android tablet for daily use", 699.99, "Samsung"),
            ("P007", "PlayStation 5", "Next-generation gaming console", 649.99, "Sony"),
            ("P008", "WH-1000XM5", "Premium wireless headphones", 499.99, "Sony"),
            ("P009", "Surface Pro", "Tablet-laptop hybrid for professionals", 1399.99, "Microsoft"),
            ("P010", "ThinkPad X1", "Business laptop with strong durability", 1599.99, "Lenovo")
        ]

        for item in sampleProducts {
            let newProduct = ProductEntity(context: viewContext)
            newProduct.id = UUID()
            newProduct.productID = item.0
            newProduct.name = item.1
            newProduct.productDescription = item.2
            newProduct.price = item.3
            newProduct.provider = item.4
        }

        do {
            try viewContext.save()
        } catch {
            print("Failed to seed products: \(error.localizedDescription)")
        }
    }

    private func resetSampleProducts() {
        for product in products {
            viewContext.delete(product)
        }

        do {
            try viewContext.save()
            currentIndex = 0
            seedProductsIfNeeded()
        } catch {
            print("Failed to reset products: \(error.localizedDescription)")
        }
    }
}
