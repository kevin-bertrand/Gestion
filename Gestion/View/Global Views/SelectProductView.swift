//
//  SelectProductView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct SelectProductView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var productsController: ProductsController
    @EnvironmentObject var userController: UserController
    
    @Binding var selectedProducts: [Product.Informations]
    @State private var quantity: String = ""
    @State private var quantityNotEntered: Bool = false
    
    var body: some View {
        VStack {
            Group {
                TextField("Quantity", text: $quantity)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                
                if quantityNotEntered {
                    Text("Enter a quanity")
                        .foregroundColor(.red)
                }
            }.padding()
            
            List {
                Section {
                    ForEach(productsController.products, id: \.id) { product in
                        if product.productCategory == .material {
                            ProductTileView(title: product.title, price: product.price, unity: product.unity)
                                .onTapGesture {
                                    if quantity.isNotEmpty,
                                       let quantityDouble = Double(quantity) {
                                        selectedProducts.append(Product.Informations(id: product.id,
                                                                                     quantity: quantityDouble,
                                                                                     title: product.title,
                                                                                     unity: product.unity,
                                                                                     domain: product.domain,
                                                                                     productCategory: product.productCategory,
                                                                                     price: product.price))
                                        self.presentationMode.wrappedValue.dismiss()
                                    } else {
                                        quantityNotEntered = true
                                    }
                                }
                        }
                    }
                } header: {
                    Text("Materials")
                }
                
                Section {
                    ForEach(productsController.products, id: \.id) { product in
                        if product.productCategory == .service {
                            ProductTileView(title: product.title, price: product.price, unity: product.unity)
                                .onTapGesture {
                                    if quantity.isNotEmpty,
                                       let quantityDouble = Double(quantity) {
                                        selectedProducts.append(Product.Informations(id: product.id,
                                                                                     quantity: quantityDouble,
                                                                                     title: product.title,
                                                                                     unity: product.unity,
                                                                                     domain: product.domain,
                                                                                     productCategory: product.productCategory,
                                                                                     price: product.price))
                                        self.presentationMode.wrappedValue.dismiss()
                                    } else {
                                        quantityNotEntered = true
                                    }
                                }
                        }
                    }
                } header: {
                    Text("Services")
                }
                
                Section {
                    ForEach(productsController.products, id: \.id) { product in
                        if product.productCategory == .divers {
                            ProductTileView(title: product.title, price: product.price, unity: product.unity)
                                .onTapGesture {
                                    if quantity.isNotEmpty,
                                       let quantityDouble = Double(quantity) {
                                        selectedProducts.append(Product.Informations(id: product.id,
                                                                                     quantity: quantityDouble,
                                                                                     title: product.title,
                                                                                     unity: product.unity,
                                                                                     domain: product.domain,
                                                                                     productCategory: product.productCategory,
                                                                                     price: product.price))
                                        self.presentationMode.wrappedValue.dismiss()
                                    } else {
                                        quantityNotEntered = true
                                    }
                                }
                        }
                    }
                } header: {
                    Text("Divers")
                }
            }.searchable(text: .constant(""))
        }
        .navigationTitle("Select product")
        .onAppear {
            productsController.gettingProductList(for: userController.connectedUser)
        }
    }
}

struct SelectProductView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SelectProductView(selectedProducts: .constant([.init(id: UUID(uuid: UUID_NULL), quantity: 0, title: "", unity: "", domain: .automation, productCategory: .material, price: 0)]))
                .environmentObject(ProductsController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
