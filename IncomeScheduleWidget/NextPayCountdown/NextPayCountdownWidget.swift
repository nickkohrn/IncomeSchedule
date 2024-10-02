//import SwiftUI
//import WidgetKit
//
//internal struct NextPayCountdownWidget: Widget {
//    internal let kind: String = "NextPayCountdownWidget"
//
//    internal var body: some WidgetConfiguration {
//        AppIntentConfiguration(
//            kind: kind,
//            intent: NextPayCountdownConfigurationAppIntent.self,
//            provider: NextPayCountdownTimelineProvider()
//        ) { entry in
//            NextPayCountdownWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//        .configurationDisplayName(Text("Days Until Next Pay"))
//        .description(Text("Shows the number of days until the next pay."))
//        .supportedFamilies([
//            .systemSmall
//        ])
//    }
//}
