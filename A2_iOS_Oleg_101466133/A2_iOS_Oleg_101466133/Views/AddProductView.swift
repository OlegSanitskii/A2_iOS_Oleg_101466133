//  A2_iOS_Oleg_101466133


import SwiftUI

struct AddProductView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var productID = ""
    @State private var name = ""
    @State private var productDescription = ""
    @State private var price = ""
    @State private var provider = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Product Information") {
                    TextField("Product ID", text: $productID)
                    TextField("Product Name", text: $name)
                    TextField("Description", text: $productDescription)
                    TextField("Price", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Provider", text: $provider)
                }

                Section {
                    Button("Add Product") {
                        addProduct()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Add Product")
            .alert("Message", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func addProduct() {
        guard !productID.isEmpty,
              !name.isEmpty,
              !productDescription.isEmpty,
              !price.isEmpty,
              !provider.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }

        guard let priceValue = Double(price) else {
            alertMessage = "Please enter a valid price."
            showAlert = true
            return
        }

        let product = ProductEntity(context: viewContext)
        product.id = UUID()
        product.productID = productID
        product.name = name
        product.productDescription = productDescription
        product.price = priceValue
        product.provider = provider

        do {
            try viewContext.save()

            productID = ""
            name = ""
            productDescription = ""
            price = ""
            provider = ""

            alertMessage = "Product added successfully."
            showAlert = true
        } catch {
            alertMessage = "Failed to save product."
            showAlert = true
        }
    }
}
