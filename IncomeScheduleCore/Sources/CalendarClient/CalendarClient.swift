import Dependencies
import DependenciesMacros
import Foundation
import IdentifiedCollections
import Models

@DependencyClient
public struct CalendarClient {
    public enum Error: Swift.Error {
        case invalidDate
    }
    
    public var monthStartDates: @Sendable (_ forDate: Date) throws -> [Date]
}

extension CalendarClient: DependencyKey {
    public static let liveValue: CalendarClient = {
        @Dependency(\.calendar) var calendar
        return CalendarClient(
            monthStartDates: { date in
                // Get the start of the current year.
                guard let interval = calendar.dateInterval(
                    of: .year,
                    for: date
                ) else {
                    throw Error.invalidDate
                }
                let start = interval.start
                let end = interval.end
                var dates = [start]
                var iterationDate = start
                while iterationDate < end {
                    guard let nextMonthStartDate = calendar.date(
                        byAdding: .month,
                        value: 1,
                        to: iterationDate
                    ) else {
                        throw Error.invalidDate
                    }
                    guard calendar.isDate(
                        nextMonthStartDate,
                        equalTo: start,
                        toGranularity: .year
                    ) else {
                        break
                    }
                    dates.append(nextMonthStartDate)
                    iterationDate = nextMonthStartDate
                }
                return dates
            }
        )
    }()
}

extension CalendarClient: Sendable {}

extension DependencyValues {
    public var calendarClient: CalendarClient {
        get { self[CalendarClient.self] }
        set { self[CalendarClient.self] = newValue }
    }
}
