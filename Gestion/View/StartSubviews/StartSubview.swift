//
//  StartSubview.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct StartSubview: View {
    @Binding var showLogin: Bool
    @Binding var showSignup: Bool
    @Binding var startSubviewTransitionIn: AnyTransition
    @Binding var startSubviewTransitionOut: AnyTransition
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .frame(width: 110, height: 150)
                .padding()
            Spacer()
            
            Group {
                ButtonCustom(isLoading: .constant(false), action: {
                    self.startSubviewTransitionIn = .backslide.combined(with: .opacity)
                    self.startSubviewTransitionOut = .slide.combined(with: .opacity)
                    withAnimation {
                        showLogin = true
                    }
                }, title: "Log in")
                
                ButtonCustom(isLoading: .constant(false), action: {
                    self.startSubviewTransitionOut = .backslide.combined(with: .opacity)
                    self.startSubviewTransitionIn = .slide.combined(with: .opacity)
                    withAnimation {
                        showSignup = true
                    }
                }, color: .white, fontColor: .accentColor, title: "Sign up")
            }
            .padding()
            
            Spacer()
        }
    }
}

struct StartSubview_Previews: PreviewProvider {
    static var previews: some View {
        StartSubview(showLogin: .constant(false), showSignup: .constant(false), startSubviewTransitionIn: .constant(.backslide), startSubviewTransitionOut: .constant(.backslide))
    }
}
