import SwiftUI
import WidgetKit

internal struct NextMonthWidget: Widget {
    internal let kind: String = "NextMonthWidget"

    internal var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: NextMonthConfigurationAppIntent.self,
            provider: NextMonthTimelineProvider()
        ) { entry in
            NextMonthWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName(Text("Pays for Next Month"))
        .description(Text("Shows the number of pays for the next month."))
        .supportedFamilies([
            .systemSmall
        ])
    }
}
