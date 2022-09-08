//
//  ProductListView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct ProductListView: View {
    @EnvironmentObject var productsController: ProductsController
    @EnvironmentObject var userController: UserController
    
    var body: some View {
        List {
            ProductsListSectionView(title: "Materials",
                                    products: productsController.products,
                                    filter: .material)
            
            ProductsListSectionView(title: "Services",
                                    products: productsController.products,
                                    filter: .service)
            
            ProductsListSectionView(title: "Divers",
                                    products: productsController.products,
                                    filter: .divers)
        }
        .navigationTitle("Product list")
        .onAppear {
            productsController.gettingProductList(for: userController.connectedUser)
        }
        .toolbar {
            NavigationLink {
                ProductCreateView()
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductListView()
                .environmentObject(UserController(appController: AppController()))
                .environmentObject(ProductsController(appController: AppController()))
        }
    }
}
