import ComposableArchitecture
import Dependencies
import Models
import PayClient
import SharedStateExtensions
import WidgetKit

internal struct NextMonthTimelineProvider: AppIntentTimelineProvider {
    internal func placeholder(in context: Context) -> NextMonthTimelineEntry {
//        placeholder()
        NextMonthTimelineEntry(date: .now, spellNumbers: true)
    }
    
    internal func snapshot(
        for configuration: NextMonthConfigurationAppIntent,
        in context: Context
    ) async -> NextMonthTimelineEntry {
//        placeholder()
        NextMonthTimelineEntry(date: .now, spellNumbers: true)
    }
    
    internal func timeline(
        for configuration: NextMonthConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<NextMonthTimelineEntry> {
        // Get the first date of the next month so that the timeline will be updated when the new month starts.
//        @Dependency(\.calendar) var calendar
//        @Dependency(\.date.now) var now
//        @Shared(.incomeSchedule) var incomeSchedule
//        do {
//            let schedule = try ScheduleClient.liveValue.nextMonthSchedule(
//                currentDate: now,
//                incomeSchedule: incomeSchedule
//            )
//            let entry = NextMonthTimelineEntry(
//                date: calendar.startOfDay(for: now),
//                schedule: schedule,
//                spellNumbers: configuration.spellNumbers
//            )
//            return Timeline(entries: [entry], policy: .atEnd)
//        } catch {
//            return Timeline(entries: [], policy: .atEnd)
//        }
        return Timeline(entries: [], policy: .never)
    }
    
//    private func placeholder() -> NextMonthTimelineEntry {
//        @Dependency(\.calendar) var calendar
//        @Dependency(\.date.now) var now
//        @Dependency(\.uuid) var uuid
//        @Shared(.incomeSchedule) var incomeSchedule
//        do {
//            let schedule = try ScheduleClient.liveValue.nextMonthSchedule(
//                currentDate: now,
//                incomeSchedule: incomeSchedule
//            )
//            let entry = NextMonthTimelineEntry(
//                date: calendar.startOfDay(for: now),
//                schedule: schedule,
//                spellNumbers: false
//            )
//            return entry
//        } catch {
//            return NextMonthTimelineEntry(
//                date: .now,
//                schedule: MonthSchedule(
//                    incomeDates: [now],
//                    uuid: uuid()
//                ),
//                spellNumbers: false
//            )
//        }
//    }
}
