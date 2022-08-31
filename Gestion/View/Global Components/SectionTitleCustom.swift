//
//  SectionTitleCustom.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct SectionTitleCustom: View {
    let title: String
    var hasButton: Bool = false
    var buttonAction: () -> Void = {}
    var buttonName: String = "See all"
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title3)
                .bold()
            Spacer()
            if hasButton {
                Button(action: buttonAction) {
                    Text(buttonName)
                }
            }
        }
    }
}

struct SectionTitleCustom_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitleCustom(title: "Hello")
    }
}
