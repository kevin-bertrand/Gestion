//
//  SelectProductSection.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct SelectProductSection: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var quantity: String
    @Binding var reduction: String
    @Binding var quantityNotEntered: Bool
    @Binding var selectedProducts: [Product.Informations]
    
    let title: String
    let list: [Product]
    let category: ProductCategory
    
    var body: some View {
        Section {
            ForEach(list, id: \.id) { product in
                if product.productCategory == category {
                    ProductTileView(title: product.title, price: product.price, unity: product.unity)
                        .onTapGesture {
                            if reduction == "" {
                                reduction = "0"
                            }
                            
                            if quantity.isNotEmpty,
                               let quantityDouble = Double(quantity),
                               let reductionDouble = Double(reduction) {
                                selectedProducts.append(product.toInformation(with: quantityDouble, and: reductionDouble))
                                dismiss()
                            } else {
                                quantityNotEntered = true
                            }
                        }
                }
            }
        } header: {
            Text(title)
        }
    }
}

struct SelectProductSection_Previews: PreviewProvider {
    static var previews: some View {
        SelectProductSection(quantity: .constant(""), reduction: .constant(""), quantityNotEntered: .constant(true), selectedProducts: .constant([]), title: "", list: [], category: .material)
    }
}
