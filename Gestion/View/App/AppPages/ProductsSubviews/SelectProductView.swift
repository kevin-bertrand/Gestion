//
//  SelectProductView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct SelectProductView: View {
    @EnvironmentObject var productsController: ProductsController
    @EnvironmentObject var userController: UserController
    
    @Binding var selectedProducts: [Product.Informations]
    @State private var quantity: String = ""
    @State private var reduction: String = ""
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
                HStack {
                    TextField("Reduction", text: $reduction)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    Text("%")
                        .padding(.leading)
                }
            }.padding()
            
            List {
                SelectProductSection(quantity: $quantity,
                                     reduction: $reduction,
                                     quantityNotEntered: $quantityNotEntered,
                                     selectedProducts: $selectedProducts,
                                     title: "Materials",
                                     list: productsController.products,
                                     category: .material)
                SelectProductSection(quantity: $quantity,
                                     reduction: $reduction,
                                     quantityNotEntered: $quantityNotEntered,
                                     selectedProducts: $selectedProducts,
                                     title: "Services",
                                     list: productsController.products,
                                     category: .service)
                SelectProductSection(quantity: $quantity,
                                     reduction: $reduction,
                                     quantityNotEntered: $quantityNotEntered,
                                     selectedProducts: $selectedProducts,
                                     title: "Divers",
                                     list: productsController.products,
                                     category: .divers)
            }
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
            SelectProductView(selectedProducts: .constant([.init(id: UUID(uuid: UUID_NULL), quantity: 0, reduction: 0, title: "", unity: "", domain: .automation, productCategory: .material, price: 0)]))
                .environmentObject(ProductsController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
