//
//  CustomButton.swift
//  Gestion-Mac
//
//  Created by Kevin Bertrand on 26/10/2022.
//

import SwiftUI

struct CustomButton: View {
    @Binding var isLoading: Bool
    
    var action: () -> Void
    var borderColor: Color = Color.accentColor
    var color: Color = Color.accentColor
    var fontColor: Color = Color.white
    var height: CGFloat = 60
    var icon: String?
    var title: String
    
    var body: some View {
        Button(action: action) {
            if isLoading {
//                ProgressView()
//                    .progressViewStyle(.circular)
//                    .padding()
            } else {
                ZStack {
                    HStack {
                        Spacer()
                        Text(title)
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    
                    if let icon = icon {
                        HStack {
                            Spacer()
                            Image(systemName: icon)
                                .padding(.horizontal)
                                .font(.title2)
                        }
                    }
                }
                
                .padding()
                .foregroundColor(fontColor)
            }
        }
        .buttonStyle(.plain)
        .background(color)
        .frame(height: height)
        .foregroundColor(.white)
        .background(color)
        .cornerRadius(25)
        .overlay(content: {
            RoundedRectangle(cornerRadius: 25)
                .strokeBorder(borderColor, style: .init(lineWidth: 1))
        })
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(isLoading: .constant(false), action: {}, title: "")
    }
}
