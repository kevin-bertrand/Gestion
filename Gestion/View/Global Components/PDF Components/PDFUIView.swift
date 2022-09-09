//
//  PDFUIView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 09/09/2022.
//

import SwiftUI
import PDFKit

struct PDFUIView: View {
    let pdf: Data
        
    var body: some View {
        PDFKitRepresentedView(pdf)
    }
}

struct PDFUIView_Previews: PreviewProvider {
    static var previews: some View {
        PDFUIView(pdf: Data())
    }
}
