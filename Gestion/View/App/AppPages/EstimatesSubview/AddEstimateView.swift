//
//  AddEstimateView.swift
//  Gestion
//
//  Created by Kevin Bertrand on 06/09/2022.
//

import SwiftUI

struct AddEstimateView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var estimatesController: EstimatesController
    @EnvironmentObject var userController: UserController
    
    @State private var newEstimate: Estimate.Create = .init(reference: "",
                                                            internalReference: "",
                                                            object: "",
                                                            totalServices: 0,
                                                            totalMaterials: 0,
                                                            totalDivers: 0,
                                                            total: 0,
                                                            reduction: 0,
                                                            grandTotal: 0,
                                                            status: .inCreation,
                                                            limitValidifyDate: "",
                                                            clientID: UUID(uuid: UUID_NULL),
                                                            products: [])
    @State private var limitDate: Date = Date()
    @State private var products: [Product.Informations] = []
    @State private var client: Client.Informations = ClientController.emptyClientInfo
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client, canSelectUser: true)
            
            Section {
                TextField("Référence interne", text: $newEstimate.internalReference)
                TextField("Object", text: $newEstimate.object)
                DatePicker(selection: $limitDate, displayedComponents: .date) {
                    Text("Date de validité")
                }
                Picker("Statut", selection: $newEstimate.status) {
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
            
            ProductListUpdateView(sectionTitle: "Services",
                                  products: $products,
                                  category: .service)
            ProductListUpdateView(sectionTitle: "Materials",
                                  products: $products,
                                  category: .material)
            ProductListUpdateView(sectionTitle: "Divers",
                                  products: $products,
                                  category: .divers)
            
            Section {
                Text("Total services: \(newEstimate.totalServices.twoDigitPrecision) €")
                Text("Total material: \(newEstimate.totalMaterials.twoDigitPrecision) €")
                Text("Total Divers: \(newEstimate.totalDivers.twoDigitPrecision) €")
                Text("Grand total: \(newEstimate.grandTotal.twoDigitPrecision) €")
                    .font(.title2.bold())
            } header: {
                Text("Total")
            }
        }
        .onChange(of: products) { newValue in
            newEstimate.totalDivers = calculateTotal(for: .divers)
            newEstimate.totalServices = calculateTotal(for: .service)
            newEstimate.totalMaterials = calculateTotal(for: .material)
            newEstimate.total = calculateTotal(for: nil)
            newEstimate.grandTotal = newEstimate.total
            
            newEstimate.products = products.map({
                .init(productID: $0.id, quantity: $0.quantity)
            })
        }
        .onChange(of: limitDate) { newValue in
            newEstimate.limitValidifyDate = newValue.ISO8601Format()
        }
        .onChange(of: client) { newValue in
            newEstimate.clientID = newValue.id ?? UUID(uuid: UUID_NULL)
        }
        .onChange(of: estimatesController.newEstimateReference) { newValue in
            newEstimate.reference = newValue
        }
        .onChange(of: estimatesController.newEstimateCreateSuccess) { newValue in
            if newValue {
                dismiss()
            }
        }
        .navigationTitle(newEstimate.reference)
        .onAppear {
            estimatesController.gettingNewReference(by: userController.connectedUser)
        }
        .toolbar {
            Button {
                estimatesController.create(estimate: newEstimate, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }

        }
    }
    
    private func calculateTotal(for category: ProductCategory?) -> Double {
        var total = 0.0
        for product in products {
            if let category = category {
                if product.productCategory == category {
                    total += (product.price * product.quantity)
                }
            } else {
                total += (product.price * product.quantity)
            }
        }
        
        return total
    }
}

struct AddEstimateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddEstimateView()
                .environmentObject(EstimatesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
