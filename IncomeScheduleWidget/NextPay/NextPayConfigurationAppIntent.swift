import AppIntents
import WidgetKit

internal struct NextPayConfigurationAppIntent: WidgetConfigurationIntent {
    internal static var title: LocalizedStringResource { "Next Pay Countdown" }
    internal static var description: IntentDescription { "Shows a countdown to your next pay." }
}
