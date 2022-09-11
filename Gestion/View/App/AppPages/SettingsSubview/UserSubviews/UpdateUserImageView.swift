//
//  UpdateUserImageView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 11/09/2022.
//

import SwiftUI

struct UpdateUserImageView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var userController: UserController
    
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(.gray)
                Text("Tap to select a picture")
                    .foregroundColor(.white)
                    .font(.headline)
                
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .clipShape(Circle())
                        .scaledToFit()
                        .overlay(Circle().stroke(style: .init(lineWidth: 1)))
                }
            }
            .padding()
            .onTapGesture {
                showingImagePicker = true
            }
            .onChange(of: inputImage) { _ in
                if let inputImage = inputImage {
                    selectedImage = inputImage
                }
            }
            
            Spacer()
            
            ButtonCustom(isLoading: .constant(false), action: {
                if let selectedImage = selectedImage {
                    userController.updateProfilePicture(selectedImage)
                }
            }, title: "Update image")
            .disabled(selectedImage == nil)
            .padding()
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: userController.updateImageSuccess) { newValue in
            if newValue {
                userController.updateImageSuccess = false
                dismiss()
            }
        }
    }
}

struct UpdateUserImageView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateUserImageView()
            .environmentObject(UserController(appController: AppController()))
    }
}
