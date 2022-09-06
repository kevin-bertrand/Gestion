//
//  ProductTileView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct ProductTileView: View {
    let title: String
    let price: Double
    let unity: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2.bold())
            Text("\(price.twoDigitPrecision) \(unity)")
        }
    }
}

struct ProductTileView_Previews: PreviewProvider {
    static var previews: some View {
        ProductTileView(title: "", price: 0, unity: "")
    }
}
