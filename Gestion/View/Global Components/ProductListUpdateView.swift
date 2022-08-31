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
    @Binding var products: [String]
    
    var body: some View {
        Section(header: Text(sectionTitle)) {
            HStack {
                Text("Adding a product")
                    .onTapGesture {
                        self.products.append("")
                        self.numberOfProducts.append(numberOfProducts.count)
                    }
                    .foregroundColor(.accentColor)
                    .font(.body.bold())
            }
            List {
                ForEach(numberOfProducts, id:\.self) { index in
                    TextField(sectionTitle, text: Binding(
                        get: { return products[index] },
                        set: { (newValue) in return self.products[index] = newValue}
                    ))
                }.onDelete { index in
                    self.products.remove(atOffsets: index)
                    self.numberOfProducts = self.numberOfProducts.dropLast(1)
                }
            }
        }
        .onAppear {
            numberOfProducts = []
            for index in 0..<products.count {
                numberOfProducts.append(index)
            }
        }
    }
}

struct ProductListUpdateView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListUpdateView(sectionTitle: "", products: .constant([]))
    }
}
