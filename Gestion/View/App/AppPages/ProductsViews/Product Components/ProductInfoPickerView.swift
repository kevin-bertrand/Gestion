//
//  ProductInfoPickerView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 07/09/2022.
//

import SwiftUI

struct ProductInfoPickerView: View {
    let icon: String?
    let title: String
    @Binding var text: any Hashable
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
            }
            Picker(title, selection: $text) {
                Text("Hello")
            }
        }
    }
}

struct ProductInfoPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ProductInfoPickerView()
    }
}
