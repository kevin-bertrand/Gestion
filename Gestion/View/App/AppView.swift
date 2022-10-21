//
//  AppView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 30/08/2022.
//

import SwiftUI

struct AppView: View {    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            iPadTabView()
        } else {
            iPhoneTabView()
        }
    }
}

struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AppView()
                .previewDevice(.init(rawValue: "iPhone 14 Pro Max"))
            AppView()
                .previewDevice(.init(rawValue: "iPad Pro (11-inch) (3rd generation)"))
        }
            .environmentObject(UserController(appController: AppController()))
            .environmentObject(EstimatesController(appController: AppController()))
            .environmentObject(InvoicesController(appController: AppController()))
            .environmentObject(RevenuesController(appController: AppController()))
    }
}
