//import ComposableArchitecture
//import Dependencies
//import Models
//import ScheduleClient
//import SharedStateExtensions
//import WidgetKit
//
//internal struct CurrentMonthTimelineProvider: AppIntentTimelineProvider {
//    internal func placeholder(in context: Context) -> CurrentMonthTimelineEntry {
//        placeholder()
//    }
//    
//    internal func snapshot(
//        for configuration: CurrentMonthConfigurationAppIntent,
//        in context: Context
//    ) async -> CurrentMonthTimelineEntry {
//        placeholder()
//    }
//    
//    internal func timeline(
//        for configuration: CurrentMonthConfigurationAppIntent,
//        in context: Context
//    ) async -> Timeline<CurrentMonthTimelineEntry> {
//        // Get the first date of the next month so that the timeline will be updated when the new month starts.
//        @Dependency(\.calendar) var calendar
//        @Dependency(\.date.now) var now
//        @Shared(.incomeSchedule) var incomeSchedule
//        do {
//            let schedule = try ScheduleClient.liveValue.currentMonthSchedule(
//                currentDate: now,
//                incomeSchedule: incomeSchedule
//            )
//            let entry = CurrentMonthTimelineEntry(
//                date: calendar.startOfDay(for: now),
//                schedule: schedule,
//                spellNumbers: configuration.spellNumbers
//            )
//            return Timeline(entries: [entry], policy: .atEnd)
//        } catch {
//            return Timeline(entries: [], policy: .atEnd)
//        }
//    }
//    
//    private func placeholder() -> CurrentMonthTimelineEntry {
//        @Dependency(\.calendar) var calendar
//        @Dependency(\.date.now) var now
//        @Dependency(\.uuid) var uuid
//        @Shared(.incomeSchedule) var incomeSchedule
//        do {
//            let schedule = try ScheduleClient.liveValue.currentMonthSchedule(
//                currentDate: now,
//                incomeSchedule: incomeSchedule
//            )
//            let entry = CurrentMonthTimelineEntry(
//                date: calendar.startOfDay(for: now),
//                schedule: schedule,
//                spellNumbers: false
//            )
//            return entry
//        } catch {
//            return CurrentMonthTimelineEntry(
//                date: .now,
//                schedule: MonthSchedule(
//                    incomeDates: [now],
//                    uuid: uuid()
//                ),
//                spellNumbers: false
//            )
//        }
//    }
//}
