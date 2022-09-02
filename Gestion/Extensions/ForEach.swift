//
//  ForEach.swift
//  Gestion
//
//  Created by Kevin Bertrand on 02/09/2022.
//

import Foundation
import SwiftUI

extension SwiftUI.ForEach where Data == Swift.Range<Swift.Int>, ID == Swift.Int, Content : SwiftUI.View {
  @_semantics("swiftui.requires_constant_range") public init(_ data: Swift.Range<Swift.Int>, @SwiftUI.ViewBuilder content: @escaping (Swift.Int) -> Content)
}
