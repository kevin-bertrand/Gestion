//
//  ProductDetailsView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct ProductDetailsView: View {
    @State var product: Product
    
    var body: some View {
        List {
            Section {
                Label(product.title, systemImage: "doc.text")
                Label("Domain: \(product.domain.rawValue)", systemImage: "tray.2.fill")
                Label("Category: \(product.productCategory.rawValue)", systemImage: "folder.fill")
                Label("\(product.price.twoDigitPrecision) \(product.unity)", systemImage: "eurosign")
            }
        }
        .navigationTitle("Details")
        .toolbar {
            NavigationLink {
                ProductUpdateView(product: $product)
            } label: {
                Image(systemName: "pencil.circle")
            }
        }
    }
}

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(product: ProductsController.emptyProduct)
    }
}
