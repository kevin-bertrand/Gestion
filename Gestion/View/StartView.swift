//
//  StartView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 29/08/2022.
//

import SwiftUI

struct StartView: View {
    @State private var showLogin: Bool = false
    @State private var showSignup: Bool = false
    @State private var startSubviewTransitionIn: AnyTransition = .backslide.combined(with: .opacity)
    @State private var startSubviewTransitionOut: AnyTransition = .slide.combined(with: .opacity)
    
    var body: some View {
        ZStack() {
            Circle()
                .foregroundColor(.init("SecondColor"))
                .frame(width: 500, height: 500)
                .position(x: 30, y: 30)
            
            Circle()
                .foregroundColor(.init("SecondColor"))
                .frame(width: 500, height: 500)
                .position(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
            
            if showLogin {
                LoginView(showLogin: $showLogin)
                    .transition(.asymmetric(insertion: .slide.combined(with: .opacity), removal: .backslide.combined(with: .opacity)))
            } else if showSignup {
                SignupSubview(showSignup: $showSignup)
                    .transition(.asymmetric(insertion: .backslide.combined(with: .opacity), removal: .slide.combined(with: .opacity)))
            } else {
                StartSubview(showLogin: $showLogin, showSignup: $showSignup, startSubviewTransitionIn: $startSubviewTransitionIn, startSubviewTransitionOut: $startSubviewTransitionOut)
                    .transition(.asymmetric(insertion: startSubviewTransitionIn, removal: startSubviewTransitionOut))
            }
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
