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
        _ date: Date,
        _ incomeSchedule: IncomeSchedule
    ) throws -> YearSchedule
}

extension ScheduleClient: DependencyKey {
    public static let liveValue: ScheduleClient = {
        ScheduleClient { date, incomeSchedule in
            @Dependency(\.calendar) var calendar
            // Get the start of the day for the pay date.
            let payDate = calendar.startOfDay(for: incomeSchedule.date)
            // Get the end of the year.
            guard
                let nextYear = calendar.date(byAdding: .year, value: 1, to: date),
                let startOfNextYear = calendar.dateInterval(of: .year, for: nextYear)?.start
            else {
                throw Error.invalidDate
            }
            // Get all pay dates until the end of the year.
            var dates = [payDate]
            switch incomeSchedule.frequency {
            case .biWeekly:
                var iterationDate = payDate
                // Get pay dates from start of month for pay date until pay date.
                guard let startOfPayDateMonth = calendar.dateInterval(of: .month, for: payDate)?.start else {
                    throw Error.invalidDate
                }
                while iterationDate > startOfPayDateMonth {
                    guard var previousDate = calendar.date(byAdding: .weekOfMonth, value: -2, to: iterationDate) else {
                        throw Error.invalidDate
                    }
                    guard previousDate >= startOfPayDateMonth else { break }
                    dates.insert(previousDate, at: 0)
                    iterationDate = previousDate
                }
                iterationDate = payDate
                // Get all bi-weekly dates between the selected pay date and the end of the year.
                while iterationDate < startOfNextYear {
                    guard let nextDate = calendar.date(byAdding: .weekOfMonth, value: 2, to: iterationDate) else {
                        throw Error.invalidDate
                    }
                    guard nextDate < startOfNextYear else { break }
                    dates.append(nextDate)
                    iterationDate = nextDate
                }
            case .weekly:
                var iterationDate = payDate
                // Get pay dates from start of month for pay date until pay date.
                guard let startOfPayDateMonth = calendar.dateInterval(of: .month, for: payDate)?.start else {
                    throw Error.invalidDate
                }
                while iterationDate > startOfPayDateMonth {
                    guard let previousDate = calendar.date(byAdding: .weekOfMonth, value: -1, to: iterationDate) else {
                        throw Error.invalidDate
                    }
                    guard previousDate >= startOfPayDateMonth else { break }
                    dates.insert(previousDate, at: 0)
                    iterationDate = previousDate
                }
                iterationDate = payDate
                // Get all weekly dates between the selected pay date and the end of the year.
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
