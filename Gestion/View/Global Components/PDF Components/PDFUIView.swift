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
            .toolbar {
                Button {
                    shareButton()
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                }
            }
    }
    
    func shareButton() {
        let activityController = UIActivityViewController(activityItems: [pdf], applicationActivities: nil)
        
        let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        window?.rootViewController?.present(activityController, animated: true, completion: nil)
    }
}

struct PDFUIView_Previews: PreviewProvider {
    static var previews: some View {
        PDFUIView(pdf: Data())
    }
}
