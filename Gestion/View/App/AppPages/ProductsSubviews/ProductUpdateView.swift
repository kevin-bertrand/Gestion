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
    @State private var productToUpdate: Product = ProductsController.emptyProduct
    @State private var price: String = ""
    
    var body: some View {
        Form {
            Section {
                TextFieldFormWithIcon(text: $productToUpdate.title,
                                      icon: "doc.text",
                                      title: "title")
                
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
                
                TextFieldFormWithIcon(text: $price,
                                      icon: "eurosign",
                                      title: "Price",
                                      keyboardType: .decimalPad)
                TextFieldFormWithIcon(text: $productToUpdate.unity,
                                      icon: nil,
                                      title: "Unity")
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
            ProductUpdateView(product: .constant(ProductsController.emptyProduct))
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(ProductsController(appController: AppController()))
        }
    }
}
