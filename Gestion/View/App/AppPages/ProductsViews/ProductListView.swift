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
            Section("Materials") {
                ForEach(productsController.products, id: \.id) { product in
                    if product.productCategory == .material {
                        NavigationLink {
                            ProductDetailsView(product: product)
                        } label: {
                            ProductTileView(title: product.title, price: product.price, unity: product.unity)
                        }
                    }
                }
            }
            
            Section("Services") {
                ForEach(productsController.products, id: \.id) { product in
                    if product.productCategory == .service {
                        NavigationLink {
                            ProductDetailsView(product: product)
                        } label: {
                            ProductTileView(title: product.title, price: product.price, unity: product.unity)
                        }
                    }
                }
            }
            
            Section("Divers") {
                ForEach(productsController.products, id: \.id) { product in
                    if product.productCategory == .divers {
                        NavigationLink {
                            ProductDetailsView(product: product)
                        } label: {
                            ProductTileView(title: product.title, price: product.price, unity: product.unity)
                        }
                    }
                }
            }
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
