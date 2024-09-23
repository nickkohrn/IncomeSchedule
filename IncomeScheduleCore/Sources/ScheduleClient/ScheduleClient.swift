import Algorithms
import Dependencies
import DependenciesMacros
import Foundation
import IdentifiedCollections
import Models

@DependencyClient
public struct ScheduleClient: Sendable {
    public enum Error: Swift.Error {
        case invalidDate
        case unknown
    }
    
    public var yearSchedule: @Sendable (
        _ currentDate: Date,
        _ incomeSchedule: IncomeSchedule
    ) throws -> YearSchedule
}

extension ScheduleClient: DependencyKey {
    public static let liveValue: ScheduleClient = {
        ScheduleClient { currentDate, incomeSchedule in
            @Dependency(\.calendar) var calendar
            var dates = [Date]()
            // 1. Get the start of the year the current date.
            guard let startOfCurrentYear = calendar.dateInterval(of: .year, for: currentDate)?.start else {
                throw Error.invalidDate
            }
            // 2. Use the recorded pay date to go backwards by the specified frequency to the first pay date of
            // the year for the current date.
            let payDate = calendar.startOfDay(for: incomeSchedule.date)
            var firstPayDateOfCurrentYear = payDate
            switch incomeSchedule.frequency {
            case .biWeekly:
                // If the start of the current year is < the logged pay date, then go backward to the first
                // pay date of the current year.
                if startOfCurrentYear < incomeSchedule.date {
                    var iterationDate = firstPayDateOfCurrentYear
                    while startOfCurrentYear < iterationDate {
                        guard var previousDate = calendar.date(byAdding: .weekOfMonth, value: -2, to: iterationDate) else {
                            throw Error.invalidDate
                        }
                        guard previousDate >= startOfCurrentYear else { break }
                        iterationDate = previousDate
                    }
                    firstPayDateOfCurrentYear = iterationDate
                // If the start of the current year is > the logged pay date, then go forward to the first
                // pay date of the current year.
                } else if startOfCurrentYear > incomeSchedule.date {
                    guard let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfCurrentYear) else {
                        throw Error.invalidDate
                    }
                    var iterationDate = firstPayDateOfCurrentYear
                    while startOfCurrentYear > iterationDate {
                        guard var nextDate = calendar.date(byAdding: .weekOfMonth, value: 2, to: iterationDate) else {
                            throw Error.invalidDate
                        }
                        guard nextDate <= startOfNextYear else { break }
                        iterationDate = nextDate
                    }
                    firstPayDateOfCurrentYear = iterationDate
                } else {
                    // TODO: Handle this
                }
            case .weekly:
                // If the start of the current year is < the logged pay date, then go backward to the first
                // pay date of the current year.
                if startOfCurrentYear < incomeSchedule.date {
                    var iterationDate = firstPayDateOfCurrentYear
                    while startOfCurrentYear < iterationDate {
                        guard var previousDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: iterationDate) else {
                            throw Error.invalidDate
                        }
                        guard previousDate >= startOfCurrentYear else { break }
                        iterationDate = previousDate
                    }
                    firstPayDateOfCurrentYear = iterationDate
                // If the start of the current year is > the logged pay date, then go forward to the first
                // pay date of the current year.
                } else if startOfCurrentYear > incomeSchedule.date {
                    guard let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfCurrentYear) else {
                        throw Error.invalidDate
                    }
                    var iterationDate = firstPayDateOfCurrentYear
                    while startOfCurrentYear > iterationDate {
                        guard var nextDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: iterationDate) else {
                            throw Error.invalidDate
                        }
                        guard nextDate <= startOfNextYear else { break }
                        iterationDate = nextDate
                    }
                    firstPayDateOfCurrentYear = iterationDate
                } else {
                    // TODO: Handle this
                }
            }
            // 3. Get all pay dates from the start of that year to the end of that year.
            guard let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfCurrentYear) else {
                throw Error.invalidDate
            }
            switch incomeSchedule.frequency {
            case .biWeekly:
                // Get all bi-weekly dates in the current year.
                var iterationDate = firstPayDateOfCurrentYear
                dates.append(firstPayDateOfCurrentYear)
                while iterationDate < startOfNextYear {
                    guard let nextDate = calendar.date(byAdding: .weekOfMonth, value: 2, to: iterationDate) else {
                        throw Error.invalidDate
                    }
                    guard nextDate < startOfNextYear else { break }
                    dates.append(nextDate)
                    iterationDate = nextDate
                }
            case .weekly:
                // Get all weekly dates in the current year.
                var iterationDate = firstPayDateOfCurrentYear
                while iterationDate < startOfNextYear {
                    guard let nextDate = calendar.date(byAdding: .weekOfMonth, value: 1, to: iterationDate) else {
                        throw Error.invalidDate
                    }
                    guard nextDate < startOfNextYear else { break }
                    dates.append(nextDate)
                    iterationDate = nextDate
                }
            }
            // Chunk all dates into months.
            let chunkedByMonth = dates.chunked {
                calendar.isDate($0, equalTo: $1, toGranularity: .month)
            }
            let arraysByMonth = chunkedByMonth.map(Array.init)
            @Dependency(\.uuid) var uuid
            let monthSchedules = arraysByMonth.map {
                MonthSchedule(incomeDates: $0, uuid: uuid())
            }
            return YearSchedule(
                monthSchedules: IdentifiedArray(uniqueElements: monthSchedules),
                uuid: uuid()
            )
        }
    }()
}

extension DependencyValues {
    public var scheduleClient: ScheduleClient {
        get { self[ScheduleClient.self] }
        set { self[ScheduleClient.self] = newValue }
    }
}
