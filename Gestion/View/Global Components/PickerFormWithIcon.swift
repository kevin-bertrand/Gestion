//
//  PickerFormWithIcon.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

import SwiftUI

struct PickerFormWithIcon: View {
    @Binding var selection: any Hashable
    let icon: String?
    let title: LocalizedStringKey
    let collection: Binding<Hashable>
    
    var body: some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
            }
                        
            Picker(title, selection: $selection) {
                ForEach(Hashable(collection), id:\.self) { row in
                    Text(row.rawValue)
                }
            }
        }
    }
}

struct PickerFormWithIcon_Previews: PreviewProvider {
    static var previews: some View {
        PickerFormWithIcon()
    }
}
