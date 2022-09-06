//
//  ProductListUpdateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct ProductListUpdateView: View {
    let sectionTitle: String
    @State private var numberOfProducts: [Int] = []
    @Binding var products: [Product.Informations]
    let category: ProductCategory
    
    var body: some View {
        Section(header: Text(sectionTitle)) {
            List {
                ForEach(products, id:\.title) { product in
                    if product.productCategory == category {
                        VStack(alignment: .leading) {
                            Text(product.title)
                                .font(.title2.bold())
                            Text("Quantity: \(product.quantity.twoDigitPrecision)")
                            Text("Price: \(product.price.twoDigitPrecision) \(product.unity ?? "")")
                            Text("Total product: \((product.quantity * product.price).twoDigitPrecision) €")
                        }
                    }
                }.onDelete { index in
                    self.products.remove(atOffsets: index)
                }
            }
        }
    }
}

struct ProductListUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListUpdateView(sectionTitle: "", products: .constant([]), category: .divers)
    }
}
