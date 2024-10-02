import SwiftUI
import WidgetKit

internal struct NextPayWidget: Widget {
    internal let kind: String = "NextPayWidget"

    internal var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: NextPayConfigurationAppIntent.self,
            provider: NextPayTimelineProvider()
        ) { entry in
            NextPayEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName(Text("Your Next Pay Date"))
        .description(Text("Shows the date of your next pay."))
        .supportedFamilies([
            .systemSmall
        ])
    }
}
