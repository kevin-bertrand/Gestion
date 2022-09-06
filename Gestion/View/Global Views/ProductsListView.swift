//
//  ProductsListView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ProductsListView: View {
    @EnvironmentObject var productsController: ProductsController
    
    var body: some View {
        List {
            Section {
                ForEach(productsController.products, id: \.id) { product in
                    if product.productCategory == .material {
                        Text(product.title)
                    }
                }
            } header: {
                Text("Materials")
            }
            
            Section {
                ForEach(productsController.products, id: \.id) { product in
                    if product.productCategory == .service {
                        Text(product.title)
                    }
                }
            } header: {
                Text("Services")
            }
            
            Section {
                ForEach(productsController.products, id: \.id) { product in
                    if product.productCategory == .divers {
                        Text(product.title)
                    }
                }
            } header: {
                Text("Divers")
            }
        }.searchable(text: .constant(""))
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView()
            .environmentObject(ProductsController(appController: AppController()))
    }
}
