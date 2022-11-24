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
    
    private let reference: String
    private let id: UUID
    
    @State private var internalReference: String
    @State private var object: String
    @State private var limitDate: Date
    @State private var sendingDate: Date
    @State private var status: EstimateStatus
    @State private var totalServices: Double
    @State private var totalMaterials: Double
    @State private var totalDivers: Double
    @State private var total: Double
    @State private var client: Client.Informations
    @State private var products: [Product.Informations]

    init(estimate: Estimate.Informations) {
        // Estimate informations
        reference = estimate.reference
        id = estimate.id
        _internalReference = State(initialValue: estimate.internalReference)
        _object = State(initialValue: estimate.object)
        _limitDate = State(initialValue: estimate.limitValidityDate)
        _sendingDate = State(initialValue: estimate.sendingDate)
        _status = State(initialValue: estimate.status)
        _totalServices = State(initialValue: estimate.totalServices)
        _totalMaterials = State(initialValue: estimate.totalMaterials)
        _totalDivers = State(initialValue: estimate.totalDivers)
        _total = State(initialValue: estimate.total)
        
        _client = State(initialValue: estimate.client)
        
        _products = State(initialValue: estimate.products)
    }
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client, canSelectUser: true)
            
            Section {
                TextField("Référence interne", text: $internalReference)
                TextField("Object", text: $object)
                DatePicker(selection: $sendingDate, displayedComponents: .date) {
                    Text("Date d'envoi")
                }
                DatePicker(selection: $limitDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $status) {
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
                                  total: $totalServices,
                                  sectionTitle: "Services",
                                  category: .service)
            ProductListUpdateView(products: $products,
                                  total: $totalMaterials,
                                  sectionTitle: "Materials",
                                  category: .material)
            ProductListUpdateView(products: $products,
                                  total: $totalDivers,
                                  sectionTitle: "Divers",
                                  category: .divers)

            TotalSectionView(totalService: totalServices,
                             totalMaterials: totalMaterials,
                             totalDivers: totalDivers,
                             total: total)
        }
        .onChange(of: products) { newValue in
            total = 0
            newValue.forEach({ total += ($0.quantity * $0.price * ((100.0 - $0.reduction)/100.0)) })
        }
        .onChange(of: estimatesController.updateEstimateSuccess) { newValue in
            if newValue {
                estimatesController.updateEstimateSuccess = false
                dismiss()
            }
        }
        .navigationTitle(reference)
        .toolbar {
            Button {
                estimatesController.update(estimate: .init(id: id,
                                                           reference: reference,
                                                           internalReference: internalReference,
                                                           object: object,
                                                           totalServices: totalServices,
                                                           totalMaterials: totalMaterials,
                                                           totalDivers: totalDivers,
                                                           total: total,
                                                           status: status,
                                                           limitValidifyDate: limitDate.ISO8601Format(),
                                                           sendingDate: sendingDate.ISO8601Format(),
                                                           products: products.map({$0.toUpdateDocuments()})),
                                           by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
    }
}

struct UpdateEstimateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateEstimateView(estimate: EstimatesManager.emptyDetail)
                .environmentObject(EstimatesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
