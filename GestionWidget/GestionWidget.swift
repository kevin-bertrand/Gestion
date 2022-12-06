//
//  GestionWidget.swift
//  GestionWidget
//
//  Created by Kevin Bertrand on 05/12/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    private let networkManager = NetworkManager()
    @AppStorage("desyntic-savedEmail", store: UserDefaults(suiteName: "group.com.desyntic.gestion")) var savedEmail: String = ""
    @AppStorage("desyntic-savedPassword", store: UserDefaults(suiteName: "group.com.desyntic.gestion")) var savedPassword: String = ""
    
    func placeholder(in context: Context) -> GestionEntry {
        GestionEntry(date: Date(), configuration: ConfigurationIntent(), data: Widgets(yearRevenues: 0, monthRevenues: 0, estimatesInCreation: 0, estimatesInWaiting: 0, invoiceInWaiting: 0, invoiceUnPaid: 0))
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (GestionEntry) -> ()) {
        let entry = GestionEntry(date: Date(), configuration: configuration, data: Widgets(yearRevenues: 0, monthRevenues: 0, estimatesInCreation: 0, estimatesInWaiting: 0, invoiceInWaiting: 0, invoiceUnPaid: 0))
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .hour, value: 6, to: currentDate) ?? currentDate.addingTimeInterval(6 * 60 * 60)

        networkManager.request(urlParams: NetworkConfigurations.widgetGetData.urlParams,
                               method: NetworkConfigurations.widgetGetData.method,
                               authorization: .authorization(username: savedEmail, password: savedPassword),
                               body: nil) { data, response, error in
            if let statusCode = response?.statusCode,
               statusCode == 200,
               let data = data,
               let informations = try? JSONDecoder().decode(Widgets.self, from: data) {
                let entry = GestionEntry(date: currentDate, configuration: configuration, data: informations)
                let timeline = Timeline(entries: [entry], policy: .after(entryDate))
                completion(timeline)
            } else {
                let entry = GestionEntry(date: currentDate, configuration: configuration, data: nil)
                let timeline = Timeline(entries: [entry], policy: .after(entryDate))
                completion(timeline)
            }
        }
    }
}

struct GestionEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let data: Widgets?
    var message: String? = nil
}

struct GestionWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry
    
    var body: some View {
        if let data = entry.data {
            switch family {
            case .systemSmall:
                SmallWidget(data: data)
            case .systemMedium:
                MediumWidget(data: data)
            default:
                Text("No data")
                    .bold()
                    .foregroundColor(.red)
            }
        } else {
            Text("No data")
                .bold()
                .foregroundColor(.red)
        }
    }
}

struct GestionWidget: Widget {
    let kind: String = "GestionWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            GestionWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Gestion")
        .description("Suivez l'évolution de votre chiffre d'affaire, de vos facture et devis.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct GestionWidget_Previews: PreviewProvider {
    static var previews: some View {
        GestionWidgetEntryView(entry: GestionEntry(date: Date(), configuration: ConfigurationIntent(), data: Widgets(yearRevenues: 0, monthRevenues: 0, estimatesInCreation: 0, estimatesInWaiting: 0, invoiceInWaiting: 0, invoiceUnPaid: 0)))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
