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
    
    public var currentMonthSchedule: @Sendable (
        _ currentDate: Date,
        _ incomeSchedule: IncomeSchedule
    ) throws -> MonthSchedule
    
    public var nextMonthSchedule: @Sendable (
        _ currentDate: Date,
        _ incomeSchedule: IncomeSchedule
    ) throws -> MonthSchedule
    
    public var nextPayDate: @Sendable (
        _ currentDate: Date,
        _ incomeSchedule: IncomeSchedule
    ) throws -> Date
    
    public var yearSchedule: @Sendable (
        _ currentDate: Date,
        _ incomeSchedule: IncomeSchedule
    ) throws -> YearSchedule
}

extension ScheduleClient: DependencyKey {
    public static let liveValue: ScheduleClient = {
        @Sendable
        func yearSchedule(currentDate: Date, incomeSchedule: IncomeSchedule) throws -> YearSchedule {
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
        return ScheduleClient(
            currentMonthSchedule: { currentDate, incomeSchedule in
                @Dependency(\.calendar) var calendar
                @Dependency(\.date.now) var now
                let yearSchedule = try yearSchedule(currentDate: currentDate, incomeSchedule: incomeSchedule)
                let currentMonthSchedule = yearSchedule.monthSchedules.first(where: { monthSchedule in
                    monthSchedule.incomeDates.contains(where: { date in
                        calendar.isDate(date, equalTo: now, toGranularity: .month)
                    })
                })
                guard let currentMonthSchedule else {
                    throw Error.invalidDate
                }
                return currentMonthSchedule
            },
            nextMonthSchedule: { currentDate, incomeSchedule in
                @Dependency(\.calendar) var calendar
                @Dependency(\.date.now) var now
                let currentYearSchedule = try yearSchedule(currentDate: currentDate, incomeSchedule: incomeSchedule)
                let currentMonthSchedule = currentYearSchedule.monthSchedules.first { monthSchedule in
                    monthSchedule.incomeDates.contains(where: { date in
                        calendar.isDate(date, equalTo: now, toGranularity: .month)
                    })
                }
                guard let currentMonthSchedule else {
                    throw Error.invalidDate
                }
                let currentMonthScheduleIndex = currentYearSchedule.monthSchedules.index(id: currentMonthSchedule.id)
                if currentMonthSchedule.id == currentYearSchedule.monthSchedules.last?.id,
                    (now > currentYearSchedule.monthSchedules.last?.incomeDates.last ?? now) {
                    // The last month in the current year has passed; calculate first month of next year.
                    guard
                        let startOfCurrentYear = calendar.dateInterval(of: .year, for: currentDate)?.start,
                        let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfCurrentYear)
                    else {
                        throw Error.invalidDate
                    }
                    let nextYearSchedule = try yearSchedule(currentDate: startOfNextYear, incomeSchedule: incomeSchedule)
                    guard let firstMonthScheduleOfNextYear = nextYearSchedule.monthSchedules.first else {
                        throw Error.invalidDate
                    }
                    return firstMonthScheduleOfNextYear
                } else {
                    // Calculate next month schedule in current year.
                    guard let currentMonthScheduleIndex else {
                        throw Error.invalidDate
                    }
                    let nextMonthScheduleIndex = currentYearSchedule.monthSchedules.index(after: currentMonthScheduleIndex)
                    return currentYearSchedule.monthSchedules[nextMonthScheduleIndex]
                }
            },
            nextPayDate: { currentDate, incomeSchedule in
                @Dependency(\.calendar) var calendar
                @Dependency(\.date.now) var now
                let currentYearSchedule = try yearSchedule(currentDate: currentDate, incomeSchedule: incomeSchedule)
                let currentMonthSchedule = currentYearSchedule.monthSchedules.first { monthSchedule in
                    monthSchedule.incomeDates.contains(where: { date in
                        calendar.isDate(date, equalTo: now, toGranularity: .month)
                    })
                }
                guard let currentMonthSchedule else {
                    throw Error.invalidDate
                }
                let currentMonthScheduleIndex = currentYearSchedule.monthSchedules.index(id: currentMonthSchedule.id)
                if currentMonthSchedule.id == currentYearSchedule.monthSchedules.last?.id,
                    (now > currentYearSchedule.monthSchedules.last?.incomeDates.last ?? now) {
                    // The last pay date has passed; calculate first pay date of next year.
                    guard
                        let startOfCurrentYear = calendar.dateInterval(of: .year, for: currentDate)?.start,
                        let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfCurrentYear)
                    else {
                        throw Error.invalidDate
                    }
                    let nextYearSchedule = try yearSchedule(currentDate: startOfNextYear, incomeSchedule: incomeSchedule)
                    guard let firstPayDateOfNextYear = nextYearSchedule.monthSchedules.first?.incomeDates.first else {
                        throw Error.invalidDate
                    }
                    return firstPayDateOfNextYear
                } else {
                    // Calculate next pay date in current year.
                    let allDates = currentYearSchedule.monthSchedules.flatMap(\.incomeDates)
                    let nextPayDate = allDates.first { date in
                        calendar.startOfDay(for: date) >= calendar.startOfDay(for: now)
                    }
                    guard let nextPayDate else {
                        throw Error.invalidDate
                    }
                    return nextPayDate
                }
            },
            yearSchedule: yearSchedule(currentDate:incomeSchedule:)
        )
    }()
}

extension DependencyValues {
    public var scheduleClient: ScheduleClient {
        get { self[ScheduleClient.self] }
        set { self[ScheduleClient.self] = newValue }
    }
}
