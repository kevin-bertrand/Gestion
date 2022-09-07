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
    
    @State private var newProduct: Product.Create = .init(productCategory: .divers, title: "", domain: .automation, unity: "", price: 0)
    @State private var price: String = ""
    
    var body: some View {
        Form {
            Section {
                ProductInformationTextField(icon: "doc.text", title: "Title", text: $newProduct.title)
                
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
                
                ProductInformationTextField(icon: "eurosign", title: "Price", text: $price, keyboardType: .decimalPad)
                ProductInformationTextField(icon: nil, title: "Unity", text: $newProduct.unity)
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
