//
//  GestionWidgetBundle.swift
//  GestionWidget
//
//  Created by Kevin Bertrand on 05/12/2022.
//

import WidgetKit
import SwiftUI

@main
struct GestionWidgetBundle: WidgetBundle {
    var body: some Widget {
        GestionWidget()
        GestionWidgetLiveActivity()
    }
}
