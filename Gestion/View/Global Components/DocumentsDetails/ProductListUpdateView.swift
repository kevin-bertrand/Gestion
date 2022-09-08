//
//  ProductListUpdateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 31/08/2022.
//

import SwiftUI

struct ProductListUpdateView: View {
    @Binding var products: [Product.Informations]
    @Binding var total: Double
    
    let sectionTitle: String
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
        .onChange(of: products) { newValue in
            total = calculateTotal(for: category)
        }
    }
    
    private func calculateTotal(for category: ProductCategory) -> Double {
        var total = 0.0
        for product in products {
            if product.productCategory == category {
                total += (product.price * product.quantity)
            }
        }
        
        return total
    }
    
}

struct ProductListUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListUpdateView(products: .constant([]), total: .constant(0), sectionTitle: "test", category: .material)
    }
}
