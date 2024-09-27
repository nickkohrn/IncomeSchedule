import ComposableArchitecture
import Dependencies
import Models
import ScheduleClient
import SharedStateExtensions
import WidgetKit

internal struct NextPayCountdownTimelineProvider: AppIntentTimelineProvider {
    internal func placeholder(in context: Context) -> NextPayCountdownTimelineEntry {
        placeholder()
    }
    
    internal func snapshot(
        for configuration: NextPayCountdownConfigurationAppIntent,
        in context: Context
    ) async -> NextPayCountdownTimelineEntry {
        placeholder()
    }
    
    internal func timeline(
        for configuration: NextPayCountdownConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<NextPayCountdownTimelineEntry> {
        @Dependency(\.calendar) var calendar
        @Dependency(\.date.now) var now
        @Shared(.incomeSchedule) var incomeSchedule
        do {
            let nextPayDate = try ScheduleClient.liveValue.nextPayDate(
                currentDate: now,
                incomeSchedule: incomeSchedule
            )
            let entry = NextPayCountdownTimelineEntry(
                date: calendar.startOfDay(for: now),
                payDate: nextPayDate,
                spellNumbers: configuration.spellNumbers
            )
            return Timeline(entries: [entry], policy: .atEnd)
        } catch {
            return Timeline(entries: [], policy: .atEnd)
        }
    }
    
    private func placeholder() -> NextPayCountdownTimelineEntry {
        @Dependency(\.calendar) var calendar
        @Dependency(\.date.now) var now
        @Dependency(\.uuid) var uuid
        return NextPayCountdownTimelineEntry(
            date: now,
            payDate: now,
            spellNumbers: false
        )
    }
}
