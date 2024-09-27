import ComposableArchitecture
import Dependencies
import Models
import ScheduleClient
import SharedStateExtensions
import WidgetKit

internal struct CombinedMonthsTimelineProvider: AppIntentTimelineProvider {
    internal func placeholder(in context: Context) -> CombinedMonthsTimelineEntry {
        placeholder()
    }
    
    internal func snapshot(
        for configuration: CombinedMonthsConfigurationAppIntent,
        in context: Context
    ) async -> CombinedMonthsTimelineEntry {
        placeholder()
    }
    
    internal func timeline(
        for configuration: CombinedMonthsConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<CombinedMonthsTimelineEntry> {
        // Get the first date of the next month so that the timeline will be updated when the new month starts.
        @Dependency(\.calendar) var calendar
        @Dependency(\.date.now) var now
        @Shared(.incomeSchedule) var incomeSchedule
        do {
            let currentMonthSchedule = try ScheduleClient.liveValue.currentMonthSchedule(
                currentDate: now,
                incomeSchedule: incomeSchedule
            )
            let nextMonthSchedule = try ScheduleClient.liveValue.nextMonthSchedule(
                currentDate: now,
                incomeSchedule: incomeSchedule
            )
            let entry = CombinedMonthsTimelineEntry(
                date: calendar.startOfDay(for: now),
                currentSchedule: currentMonthSchedule,
                nextSchedule: nextMonthSchedule,
                spellNumbers: configuration.spellNumbers
            )
            return Timeline(entries: [entry], policy: .atEnd)
        } catch {
            return Timeline(entries: [], policy: .atEnd)
        }
    }
    
    private func placeholder() -> CombinedMonthsTimelineEntry {
        @Dependency(\.calendar) var calendar
        @Dependency(\.date.now) var now
        @Dependency(\.uuid) var uuid
        guard
            let startOfCurrentMonth = calendar.dateInterval(of: .month, for: now)?.start,
            let secondDateOfCurrentMonth = calendar.date(byAdding: .day, value: 7, to: startOfCurrentMonth),
            let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfCurrentMonth),
            let secondDateOfNextMonth = calendar.date(byAdding: .day, value: 7, to: startOfCurrentMonth)
        else {
            return CombinedMonthsTimelineEntry(
                date: .now,
                currentSchedule: MonthSchedule(
                    incomeDates: [],
                    uuid: uuid()
                ),
                nextSchedule: MonthSchedule(
                    incomeDates: [],
                    uuid: uuid()
                ),
                spellNumbers: false
            )
        }
        return CombinedMonthsTimelineEntry(
            date: .now,
            currentSchedule: MonthSchedule(
                incomeDates: [
                    startOfCurrentMonth,
                    secondDateOfCurrentMonth
                ],
                uuid: uuid()
            ),
            nextSchedule: MonthSchedule(
                incomeDates: [
                    startOfNextMonth,
                    secondDateOfNextMonth
                ],
                uuid: uuid()
            ),
            spellNumbers: false
        )
    }
}
