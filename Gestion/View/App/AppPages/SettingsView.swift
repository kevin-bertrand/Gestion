//
//  SettingsView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct SettingsView: View {
    @State private var useDefaultColorScheme: Bool = true
    @State private var useDarkMode: Bool = false
    @State private var allowNotifications: Bool = true
    
    var body: some View {
        VStack {
            Form {
                Section {
                    UserCellView()
                }.listRowBackground(Color.clear)
                
                Section {
                    NavigationLink {
                        Text("Update personnal informations")
                    } label: {
                        Label("Update personnal informations", systemImage: "person.fill")
                    }
                    NavigationLink {
                        Text("Update picture")
                    } label: {
                        Label("Update picture", systemImage: "camera.fill")
                    }
                    NavigationLink {
                        Text("Password update")
                    } label: {
                        Label("Update password", systemImage: "lock.fill")
                    }
                } header: {
                    Text("Account settings")
                }
                
                Section {
                    NavigationLink {
                        Label("Client list", systemImage: "person.3.fill")
                    } label: {
                        Label("Client list", systemImage: "person.3.fill")
                    }

                    NavigationLink {
                        Label("Articles categories", systemImage: "folder.fill")
                    } label: {
                        Label("Articles categories", systemImage: "folder.fill")
                    }
                    
                    NavigationLink {
                        Label("Article domain", systemImage: "tray.2.fill")
                    } label: {
                        Label("Article domain", systemImage: "tray.2.fill")
                    }
                    
                    NavigationLink {
                        Label("Articles", systemImage: "list.bullet.rectangle.fill")
                    } label: {
                        Label("Articles", systemImage: "list.bullet.rectangle.fill")
                    }
                } header: {
                    Text("Commpany settings")
                }
                
                Section {
                    Toggle("Use default iPhone scheme", isOn: $useDefaultColorScheme)
                        .disabled(true)
                    
                    if !useDefaultColorScheme {
                        Toggle("Use dark mode", isOn: $useDarkMode)
                            .disabled(true)
                    }
                                        
                    Toggle("Allow notifications", isOn: $allowNotifications)
                        .disabled(true)
                } header: {
                    Text("App settings")
                }
                
                Section {
                    Button {
                        // TODO: Disconnect
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
        }.navigationTitle(Text("Settings"))
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView()
        }
    }
}
