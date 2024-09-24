import AppIntents
import WidgetKit

internal struct NextPayCountdownConfigurationAppIntent: WidgetConfigurationIntent {
    internal static var title: LocalizedStringResource { "Next Pay Countdown" }
    internal static var description: IntentDescription { "Shows a countdown to your next pay." }
    
    @Parameter(title: "Spell Numbers", description: "Whether numbers should be spelled out.", default: false)
    internal var spellNumbers: Bool
}
