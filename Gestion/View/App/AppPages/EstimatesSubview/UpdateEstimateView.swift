//
//  UpdateEstimateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct UpdateEstimateView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var estimatesController: EstimatesController
    @EnvironmentObject var userController: UserController
    
    @State var estimate: Estimate.Update
    @State var client: Client.Informations
    @State var products: [Product.Informations] = []
    @State private var limitDate: Date = Date()
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client)
            
            Section {
                TextField("Référence interne", text: $estimate.internalReference)
                TextField("Object", text: $estimate.object)
                DatePicker(selection: $limitDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $estimate.status) {
                    ForEach(EstimateStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                    }
                }
            } header: {
                Text("Informations")
            }
            
            Section {
                NavigationLink {
                    SelectProductView(selectedProducts: $products)
                } label: {
                    Text("Select new product")
                        .foregroundColor(.accentColor)
                }
            }
            
            ProductListUpdateView(products: $products,
                                  total: $estimate.totalServices,
                                  sectionTitle: "Services",
                                  category: .service)
            ProductListUpdateView(products: $products,
                                  total: $estimate.totalMaterials,
                                  sectionTitle: "Materials",
                                  category: .material)
            ProductListUpdateView(products: $products,
                                  total: $estimate.totalDivers,
                                  sectionTitle: "Divers",
                                  category: .divers)
            
            TotalSectionView(totalService: estimate.totalServices, totalMaterials: estimate.totalMaterials, totalDivers: estimate.totalDivers, grandTotal: estimate.grandTotal)            
        }
        .onChange(of: products) { newValue in
            estimate.total = 0
            newValue.forEach({ estimate.total += ($0.quantity * $0.price) })
            estimate.grandTotal = estimate.total
            
            estimate.products = products.map({
                .init(productID: $0.id, quantity: $0.quantity)
            })
        }
        .onChange(of: limitDate) { newValue in
            estimate.limitValidifyDate = newValue.ISO8601Format()
        }
        .onChange(of: estimatesController.updateEstimateSuccess) { newValue in
            if newValue {
                estimatesController.updateEstimateSuccess = false
                dismiss()
            }
        }
        .navigationTitle(estimate.reference)
        .toolbar {
            Button {
                estimatesController.update(estimate: estimate, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
    }
}

struct UpdateEstimateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateEstimateView(estimate: EstimatesController.emptyUpdateEstimate, client: ClientController.emptyClientInfo)
                .environmentObject(EstimatesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
