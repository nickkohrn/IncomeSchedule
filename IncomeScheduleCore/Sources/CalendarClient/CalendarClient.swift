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
    
    public var year: @Sendable (_ forDate: Date) throws -> Year
}

extension CalendarClient: DependencyKey {
    public static let liveValue: CalendarClient = {
        @Dependency(\.calendar) var calendar
        return CalendarClient(
            year: { date in
                // Get the start of the current year.
                guard let interval = calendar.dateInterval(
                    of: .year,
                    for: date
                ) else {
                    throw Error.invalidDate
                }
                let start = interval.start
                let end = interval.end
                var months = [Month(startDate: start)]
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
                    months.append(Month(startDate: nextMonthStartDate))
                    iterationDate = nextMonthStartDate
                }
                return Year(
                    startDate: start,
                    months: IdentifiedArray(uniqueElements: months)
                )
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
