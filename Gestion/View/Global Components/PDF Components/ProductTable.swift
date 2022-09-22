//
//  ProductTable.swift
//  Gestion
//
//  Created by Kevin Bertrand on 08/09/2022.
//

//import SwiftUI
//
//struct ProductTable: View {
//    let products: [Product.Informations]
//    let totalServices: Double
//    let totalMaterials: Double
//    let totalDivers: Double
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            TableColumnTitles()
//            if totalServices > 0 {
//                TableSectionTitle(title: "Services")
//                ForEach(products, id: \.title) { product in
//                    if product.productCategory == .service {
//                        TableRow(title: product.title, quantity: product.quantity, unity: product.unity ?? "", unitaryPrice: product.price)
//                    }
//                }
//                TotalSectionLine(section: "Services", total: totalServices)
//            }
//            
//            if totalMaterials > 0 {
//                TableSectionTitle(title: "Matériel")
//                ForEach(products, id: \.title) { product in
//                    if product.productCategory == .material {
//                        TableRow(title: product.title, quantity: product.quantity, unity: product.unity ?? "", unitaryPrice: product.price)
//                    }
//                }
//                TotalSectionLine(section: "Matériel", total: totalMaterials)
//            }
//            
//            if totalDivers > 0 {
//                TableSectionTitle(title: "Divers")
//                ForEach(products, id: \.title) { product in
//                    if product.productCategory == .divers {
//                        TableRow(title: product.title, quantity: product.quantity, unity: product.unity ?? "", unitaryPrice: product.price)
//                    }
//                }
//                TotalSectionLine(section: "Divers", total: totalDivers)
//            }
//        }
//    }
//}
//
//struct ProductTable_Previews: PreviewProvider {
//    static var previews: some View {
//        ProductTable(products: [], totalServices: 0, totalMaterials: 0, totalDivers: 0)
//    }
//}
