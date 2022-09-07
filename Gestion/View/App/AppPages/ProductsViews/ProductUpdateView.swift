//
//  ProductUpdateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct ProductUpdateView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var productsController: ProductsController
    @EnvironmentObject var userController: UserController
    
    @Binding var product: Product
    @State private var productToUpdate: Product = Product(id: UUID(uuid: UUID_NULL), productCategory: .divers, title: "", domain: .automation, unity: "", price: 0)
    @State private var price: String = ""
    
    var body: some View {
        Form {
            Section {
                ProductInformationTextField(icon: "doc.text", title: "Title", text: $productToUpdate.title)
                
                HStack {
                    Image(systemName: "tray.2.fill")
                    Picker("Domain", selection: $productToUpdate.domain) {
                        ForEach(Domain.allCases, id:\.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "folder.fill")
                    Picker("Category", selection: $productToUpdate.productCategory) {
                        ForEach(ProductCategory.allCases, id:\.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                ProductInformationTextField(icon: "eurosign", title: "Price", text: $price, keyboardType: .decimalPad)
                ProductInformationTextField(icon: nil, title: "Unity", text: $productToUpdate.unity)
            }
        }
        .onAppear {
            productToUpdate = product
            price = product.price.twoDigitPrecision
        }
        .navigationTitle("Update product")
        .toolbar {
            Button {
                guard let priceInDouble = Double(price) else { return }
                productToUpdate.price = priceInDouble
                productsController.updateProduct(productToUpdate, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onChange(of: productsController.productIsUpdated) { newValue in
            if newValue {
                productsController.productIsUpdated = false
                product = productToUpdate
                dismiss()
            }
        }
    }
}

struct ProductUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductUpdateView(product: .constant(Product(id: UUID(uuid: UUID_NULL), productCategory: .divers, title: "", domain: .automation, unity: "", price: 0)))
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(ProductsController(appController: AppController()))
        }
    }
}
