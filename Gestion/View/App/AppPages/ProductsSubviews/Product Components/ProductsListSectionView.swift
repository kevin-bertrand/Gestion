//
//  ProductsListSectionView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct ProductsListSectionView: View {
    let title: String
    let products: [Product]
    let filter: ProductCategory
    
    var body: some View {
        Section(title) {
            ForEach(products, id: \.id) { product in
                if product.productCategory == filter {
                    NavigationLink {
                        ProductDetailsView(product: product)
                    } label: {
                        ProductTileView(title: product.title, price: product.price, unity: product.unity)
                    }
                }
            }
        }
    }
}

struct ProductsListSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListSectionView(title: "", products: [], filter: .divers)
    }
}
