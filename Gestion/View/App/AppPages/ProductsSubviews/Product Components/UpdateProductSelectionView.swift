//
//  UpdateProductSelectionView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 20/10/2022.
//

import SwiftUI

struct UpdateProductSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var product: Product.Informations
    @State private var quantity: String = ""
    @State private var reduction: String = ""
    @State private var total: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(product.title)
                .font(.title.bold())
            Text("Price: \(product.price.twoDigitPrecision) \(product.unity ?? "")")
            Spacer()
            
            Group {
                Text("Quantity")
                TextField("Quantity", text: $quantity)
                    .keyboardType(.decimalPad)
                
                Text("Recuction")
                HStack {
                    TextField("Reduction", text: $reduction)
                        .keyboardType(.decimalPad)
                    Text("%")
                }
            }
            .textFieldStyle(.roundedBorder)
            
            Spacer()
            
            HStack {
                Spacer()
                Text("Total: \(total.twoDigitPrecision) €")
                    .font(.title.bold())
                Spacer()
            }.padding()
            
            ButtonCustom(isLoading: .constant(false), action: {
                if let reductionDouble = Double(reduction), let quantityDouble = Double(quantity) {
                    product.quantity = quantityDouble
                    product.reduction = reductionDouble
                }
                dismiss()
            }, borderColor: .accentColor, title: "Update")
        }
        .padding()
        .onAppear {
            quantity = product.quantity.twoDigitPrecision
            reduction = product.reduction.twoDigitPrecision
            total = product.price * product.quantity * (1-(product.reduction/100))
        }
        .onChange(of: quantity) { newValue in
            caclulateTotal()
        }
        .onChange(of: reduction) { newValue in
            caclulateTotal()
        }
    }
    
    private func caclulateTotal() {
        if let reductionDouble = Double(reduction), let quantityDouble = Double(quantity) {
            total = product.price * (1-(reductionDouble/100)) * quantityDouble
        }
    }
}

struct UpdateProductSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateProductSelectionView(product: .constant(Product.Informations(id: UUID(), quantity: 10, reduction: 5, title: "test", unity: nil, domain: .automation, productCategory: .divers, price: 10)))
    }
}
