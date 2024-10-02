import ComposableArchitecture
import Dependencies
import Models
import PayClient
import SharedStateExtensions
import WidgetKit

internal struct NextPayTimelineProvider: AppIntentTimelineProvider {
    internal func placeholder(in context: Context) -> NextPayTimelineEntry {
        NextPayTimelineEntry(
            date: .now,
            payDate: CoalescedPayDate(
                date: .now,
                sources: [
                    PaySource(
                        name: "My Job",
                        frequency: .biWeekly,
                        referencePayDate: .now,
                        uuid: UUID()
                    )
                ],
                uuid: UUID()
            )
        )
    }
    
    internal func snapshot(
        for configuration: NextPayConfigurationAppIntent,
        in context: Context
    ) async -> NextPayTimelineEntry {
        do {
            @Dependency(\.date.now) var now
            @Dependency(\.payClient) var payClient
            @Shared(.paySources) var paySources
            let nextPayDate = try payClient.nextCoalescedPayDate(
                currentDate: now,
                sources: paySources
            )
            return NextPayTimelineEntry(date: now, payDate: nextPayDate)
        } catch {
            return NextPayTimelineEntry(
                date: .now,
                payDate: CoalescedPayDate(
                    date: .now,
                    sources: [
                        PaySource(
                            name: "My Job",
                            frequency: .biWeekly,
                            referencePayDate: .now,
                            uuid: UUID()
                        )
                    ],
                    uuid: UUID()
                )
            )
        }
    }
    
    internal func timeline(
        for configuration: NextPayConfigurationAppIntent,
        in context: Context
    ) async -> Timeline<NextPayTimelineEntry> {
        do {
            @Dependency(\.date.now) var now
            @Dependency(\.payClient) var payClient
            @Shared(.paySources) var paySources
            let nextPayDate = try payClient.nextCoalescedPayDate(
                currentDate: now,
                sources: paySources
            )
            let entry = NextPayTimelineEntry(date: now, payDate: nextPayDate)
            return Timeline(entries: [entry], policy: .atEnd)
        } catch {
            let entry = NextPayTimelineEntry(
                date: .now,
                payDate: CoalescedPayDate(
                    date: .now,
                    sources: [
                        PaySource(
                            name: "My Job",
                            frequency: .biWeekly,
                            referencePayDate: .now,
                            uuid: UUID()
                        )
                    ],
                    uuid: UUID()
                )
            )
            return Timeline(entries: [entry], policy: .atEnd)
        }
    }
}
