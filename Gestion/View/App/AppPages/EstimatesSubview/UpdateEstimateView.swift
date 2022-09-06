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
                Text("Total services: \(estimate.totalServices.twoDigitPrecision) €")
                Text("Total material: \(estimate.totalMaterials.twoDigitPrecision) €")
                Text("Total Divers: \(estimate.totalDivers.twoDigitPrecision) €")
                Text("Grand total: \(estimate.grandTotal.twoDigitPrecision) €")
                    .font(.title2.bold())
            } header: {
                Text("Total")
            }
        }
        .onChange(of: products) { newValue in
            estimate.totalDivers = calculateTotal(for: .divers)
            estimate.totalServices = calculateTotal(for: .service)
            estimate.totalMaterials = calculateTotal(for: .material)
            estimate.total = calculateTotal(for: nil)
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

struct UpdateEstimateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UpdateEstimateView(estimate: Estimate.Update(id: UUID(uuid: UUID_NULL), reference: "", internalReference: "", object: "", totalServices: 0, totalMaterials: 0, totalDivers: 0, total: 0, reduction: 0, grandTotal: 0, status: .inCreation, products: []), client: Client.Informations(id: nil, firstname: nil, lastname: nil, company: nil, phone: "", email: "", personType: .company, gender: nil, siret: nil, tva: nil, address: Address(id: "", roadName: "", streetNumber: "", complement: nil, zipCode: "", city: "", country: "", latitude: 0, longitude: 0, comment: nil)))
                .environmentObject(EstimatesController(appController: AppController()))
                .environmentObject(UserController(appController: AppController()))
        }
    }
}
