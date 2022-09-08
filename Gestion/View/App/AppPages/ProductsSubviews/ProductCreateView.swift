//
//  ProductCreateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct ProductCreateView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var userController: UserController
    @EnvironmentObject var productsController: ProductsController
    
    @State private var newProduct: Product.Create = ProductsController.emptyCreateProduct
    @State private var price: String = ""
    
    var body: some View {
        Form {
            Section {
                TextFieldFormWithIcon(text: $newProduct.title, icon: "doc.text", title: "Title")
                
                HStack {
                    Image(systemName: "tray.2.fill")
                    Picker("Domain", selection: $newProduct.domain) {
                        ForEach(Domain.allCases, id:\.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "folder.fill")
                    Picker("Category", selection: $newProduct.productCategory) {
                        ForEach(ProductCategory.allCases, id:\.self) {
                            Text($0.rawValue)
                        }
                    }
                }
                
                TextFieldFormWithIcon(text: $price, icon: "eurosign", title: "Price", keyboardType: .decimalPad)
                TextFieldFormWithIcon(text: $newProduct.unity, icon: nil, title: "Unity")
            }
        }
        .navigationTitle("Create product")
        .toolbar {
            Button {
                guard let priceInDouble = Double(price) else { return }
                newProduct.price = priceInDouble
                productsController.createProduct(newProduct, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
        .onChange(of: productsController.productIsCreated) { newValue in
            if newValue {
                productsController.productIsCreated = false
                dismiss()
            }
        }
    }
}

struct ProductCreateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductCreateView()
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(ProductsController(appController: AppController()))
        }
    }
}
