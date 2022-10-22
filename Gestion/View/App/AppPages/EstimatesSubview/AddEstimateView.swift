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
    
    @State private var newEstimate: Estimate.Create = EstimatesController.emptyCreateEstimate
    @State private var limitDate: Date = Date()
    @State private var products: [Product.Informations] = []
    @State private var client: Client.Informations = ClientController.emptyClientInfo
    @State private var domain: Domain = .electricity
    
    var body: some View {
        Form {
            ClientDetailsView(selectedClient: $client, canSelectUser: true)
            
            Section {
                Picker("Domain", selection: $domain) {
                    ForEach(Domain.allCases, id: \.self) { domain in
                        Text(domain.rawValue)
                    }
                }
                HStack {
                    Text("Internal ref")
                    Spacer()
                    Text(estimatesController.newInternalReference)
                        .foregroundColor(.gray)
                }
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
            
            ProductListUpdateView(products: $products,
                                  total: $newEstimate.totalServices,
                                  sectionTitle: "Services",
                                  category: .service)
            ProductListUpdateView(products: $products,
                                  total: $newEstimate.totalMaterials,
                                  sectionTitle: "Materials",
                                  category: .material)
            ProductListUpdateView(products: $products,
                                  total: $newEstimate.totalDivers,
                                  sectionTitle: "Divers",
                                  category: .divers)
            
            TotalSectionView(totalService: newEstimate.totalServices,
                             totalMaterials: newEstimate.totalMaterials,
                             totalDivers: newEstimate.totalDivers,
                             total: newEstimate.total)
        }
        .onChange(of: products) { newValue in
            newEstimate.total = 0
            newValue.forEach({ newEstimate.total += ($0.quantity * $0.price) })
            
            newEstimate.products = products.map({
                .init(productID: $0.id, quantity: $0.quantity, reduction: $0.reduction)
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
                estimatesController.newEstimateCreateSuccess = false
                dismiss()
            }
        }
        .onChange(of: domain, perform: { newValue in
            estimatesController.gettingNewInternalReference(by: userController.connectedUser, for: newValue)

        })
        .navigationTitle(newEstimate.reference)
        .onAppear {
            estimatesController.gettingNewReference(by: userController.connectedUser)
            estimatesController.gettingNewInternalReference(by: userController.connectedUser, for: domain)
        }
        .onDisappear {
            estimatesController.newEstimateReference = ""
        }
        .toolbar {
            Button {
                estimatesController.create(estimate: newEstimate, by: userController.connectedUser)
            } label: {
                Image(systemName: "v.circle")
            }
        }
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
