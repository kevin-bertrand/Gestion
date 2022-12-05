//
//  SettingsView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import LocalAuthentication
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userController: UserController
    
    @AppStorage("desyntic_useDefaultScheme") var useDefaultColorScheme: Bool = true
    @AppStorage("desyntic_useDarkMode") var useDarkMode: Bool = false
    @State private var allowNotifications: Bool = true
    @State private var showSettingsAlert: Bool = false
    private let laContext = LAContext()
    
    var body: some View {
        VStack {
            Form {
                Section {
                    UserCellView()
                }.listRowBackground(Color.clear)
                
                Section {
                    NavigationLink {
                        UserUpdateView()
                    } label: {
                        Label("Update personnal informations", systemImage: "person.fill")
                    }
                    NavigationLink {
                        UpdateUserImageView()
                    } label: {
                        Label("Update picture", systemImage: "camera.fill")
                    }
                    NavigationLink {
                        UserUpdatePasswordView()
                    } label: {
                        Label("Update password", systemImage: "lock.fill")
                    }
                } header: {
                    Text("Account settings")
                }
                
                Section {
                    NavigationLink {
                        ClientListView()
                    } label: {
                        Label("Client list", systemImage: "person.3.fill")
                    }
                    
                    NavigationLink {
                        List {
                            ForEach(ProductCategory.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }.navigationTitle("Categories")
                    } label: {
                        Label("Products categories", systemImage: "folder.fill")
                    }
                    
                    NavigationLink {
                        List {
                            ForEach(Domain.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }.navigationTitle("Domains")
                    } label: {
                        Label("Products domain", systemImage: "tray.2.fill")
                    }
                    
                    NavigationLink {
                        ProductListView()
                    } label: {
                        Label("Products", systemImage: "list.bullet.rectangle.fill")
                    }
                    
                    NavigationLink {
                        PaymentListView()
                    } label: {
                        Label("Payments", systemImage: "creditcard.fill")
                    }
                } header: {
                    Text("Commpany settings")
                }
                
                Section {
                    Toggle("Use default iPhone scheme", isOn: $useDefaultColorScheme)
                    
                    if !useDefaultColorScheme {
                        Toggle("Use dark mode", isOn: $useDarkMode)
                    }
                    
                    if userController.appController.isBiometricAvailable {
                        Toggle("Use \(laContext.biometryType == .faceID ? "Face ID" : "Touch ID" )", isOn: $userController.canUseBiometric)
                    }
                    
                    Toggle("Allow notifications", isOn: $allowNotifications)
                        .disabled(true)
                        .onTapGesture {
                            showSettingsAlert.toggle()
                        }
                } header: {
                    Text("App settings")
                }
                
                Section {
                    Button {
                        userController.disconnectUser()
                    } label: {
                        HStack {
                            Spacer()
                            Text("Disconnect")
                            Spacer()
                        }
                        .bold()
                        .foregroundColor(.red)
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("© Powered by Desyntic")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Spacer()
                    }.listRowBackground(Color.clear)
                }
            }
        }
        .navigationTitle(Text("Settings"))
        .onAppear {
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .ephemeral, .provisional:
                    self.allowNotifications = true
                default:
                    self.allowNotifications = false
                }
            }
        }
        .alert(isPresented: $showSettingsAlert) {
            Alert(title: Text("Settings"),
                  message: Text("Go to the iPhone settings' to change notifications and location authorization!"),
                  primaryButton: .default(Text("Cancel")),
                  secondaryButton: .default(Text("Go to settings"),
                                            action: {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
