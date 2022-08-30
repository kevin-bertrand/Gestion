//
//  AnyTransition.swift
//  Gestion
//
//  Created by Kevin Bertrand on 29/08/2022.
//

import Foundation
import SwiftUI

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
