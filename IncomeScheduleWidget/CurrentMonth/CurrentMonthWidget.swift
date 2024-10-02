//import SwiftUI
//import WidgetKit
//
//internal struct CurrentMonthWidget: Widget {
//    internal let kind: String = "CurrentMonthWidget"
//
//    internal var body: some WidgetConfiguration {
//        AppIntentConfiguration(
//            kind: kind,
//            intent: CurrentMonthConfigurationAppIntent.self,
//            provider: CurrentMonthTimelineProvider()
//        ) { entry in
//            CurrentMonthWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//        .configurationDisplayName(Text("Pays for Current Month"))
//        .description(Text("Shows the number of pays for the current month."))
//        .supportedFamilies([
//            .systemSmall
//        ])
//    }
//}
