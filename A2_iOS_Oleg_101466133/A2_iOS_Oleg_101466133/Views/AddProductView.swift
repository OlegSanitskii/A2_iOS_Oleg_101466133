//  A2_iOS_Oleg_101466133


import SwiftUI
import CoreData

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var productID = ""
    @State private var name = ""
    @State private var productDescription = ""
    @State private var price = ""
    @State private var provider = ""

    @State private var showAlert = false
    @State private var alertTitle = "Message"
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Student")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("Oleg Sanitskii - 101466133")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }

                Section("Product Information") {
                    TextField("Product ID", text: $productID)
                        .textInputAutocapitalization(.characters)

                    TextField("Product Name", text: $name)

                    TextField("Description", text: $productDescription, axis: .vertical)
                        .lineLimit(2...4)

                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)

                    TextField("Provider", text: $provider)
                }

                Section {
                    Button("Add Product") {
                        addProduct()
                    }
                    .frame(maxWidth: .infinity)

                    Button("Clear Form", role: .cancel) {
                        clearForm()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add Product")
            .alert(alertTitle, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func addProduct() {
        let trimmedProductID = productID
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = productDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPrice = price.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedProvider = provider.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedProductID.isEmpty,
              !trimmedName.isEmpty,
              !trimmedDescription.isEmpty,
              !trimmedPrice.isEmpty,
              !trimmedProvider.isEmpty else {
            alertTitle = "Missing Information"
            alertMessage = "Please fill in all fields before adding a product."
            showAlert = true
            return
        }

        guard let priceValue = Double(trimmedPrice), priceValue >= 0 else {
            alertTitle = "Invalid Price"
            alertMessage = "Please enter a valid non-negative price."
            showAlert = true
            return
        }

        let request: NSFetchRequest<ProductEntity> = ProductEntity.fetchRequest()
        request.predicate = NSPredicate(format: "productID ==[c] %@", trimmedProductID)
        request.fetchLimit = 1

        do {
            let existingProducts = try viewContext.fetch(request)

            if !existingProducts.isEmpty {
                alertTitle = "Duplicate Product ID"
                alertMessage = "A product with this Product ID already exists. Please use a unique Product ID."
                showAlert = true
                return
            }
        } catch {
            alertTitle = "Error"
            alertMessage = "Failed to validate Product ID."
            showAlert = true
            return
        }

        let product = ProductEntity(context: viewContext)
        product.id = UUID()
        product.productID = trimmedProductID
        product.name = trimmedName
        product.productDescription = trimmedDescription
        product.price = priceValue
        product.provider = trimmedProvider

        do {
            try viewContext.save()
            clearForm()

            alertTitle = "Success"
            alertMessage = "Product added successfully."
            showAlert = true
        } catch {
            alertTitle = "Save Failed"
            alertMessage = "The product could not be saved. Please try again."
            showAlert = true
        }
    }

    private func clearForm() {
        productID = ""
        name = ""
        productDescription = ""
        price = ""
        provider = ""
    }
}
