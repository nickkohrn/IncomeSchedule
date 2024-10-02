//import SwiftUI
//import WidgetKit
//
//internal struct CombinedMonthsWidget: Widget {
//    internal let kind: String = "CombinedMonthsWidget"
//
//    internal var body: some WidgetConfiguration {
//        AppIntentConfiguration(
//            kind: kind,
//            intent: CombinedMonthsConfigurationAppIntent.self,
//            provider: CombinedMonthsTimelineProvider()
//        ) { entry in
//            CombinedMonthsWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//        .configurationDisplayName(Text("Pays for Current & Next Months"))
//        .description(Text("Shows the number of pays for the current month and the next month."))
//        .supportedFamilies([
//            .systemSmall
//        ])
//    }
//}
