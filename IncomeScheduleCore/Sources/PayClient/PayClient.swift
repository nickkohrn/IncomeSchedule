import Algorithms
import Dependencies
import DependenciesMacros
import Foundation
import IdentifiedCollections
import Models

@DependencyClient
public struct PayClient {
    public enum Error: Swift.Error {
        case invalidDate
    }
    
    public var nextCoalescedPayDate: @Sendable (
        _ currentDate: Date,
        _ sources: IdentifiedArrayOf<PaySource>
    ) throws -> CoalescedPayDate
    
    public var year: @Sendable (
        _ selectedDate: Date,
        _ sources: IdentifiedArrayOf<PaySource>
    ) throws -> Year
}

extension PayClient: DependencyKey {
    public static let liveValue: PayClient = {
        let calendar = Calendar.current
        @Sendable
        func payDates(selectedDate: Date, source: PaySource) throws -> [PayDate] {
            guard let yearInterval = calendar.dateInterval(of: .year, for: selectedDate) else {
                throw Error.invalidDate
            }
            // 1. Get the start and end of the year for the current date.
            let startOfYear = yearInterval.start
            let startOfNextYear = yearInterval.end
            var dates = [Date]()
            // 2. Use the reference pay date to go backwards by the specified frequency to the
            // first pay date of the year for the current date.
            let payDate = calendar.startOfDay(for: source.referencePayDate)
            var firstPayDateOfCurrentYear = payDate
            switch source.frequency {
            case .biWeekly:
                if startOfYear < source.referencePayDate {
                    // If the start of the year is less-than the reference pay date, then go
                    // backward to the first pay date of the year.
                    var iterationDate = firstPayDateOfCurrentYear
                    while startOfYear < iterationDate {
                        guard var previousDate = calendar.date(
                            byAdding: .weekOfMonth,
                            value: -2,
                            to: iterationDate
                        ) else {
                            throw Error.invalidDate
                        }
                        guard previousDate >= startOfYear else { break }
                        iterationDate = previousDate
                    }
                    dates.append(iterationDate)
                    while iterationDate < startOfNextYear {
                        guard var nextDate = calendar.date(
                            byAdding: .weekOfMonth,
                            value: 2,
                            to: iterationDate
                        ) else {
                            throw Error.invalidDate
                        }
                        guard nextDate < startOfNextYear else { break }
                        dates.append(nextDate)
                        iterationDate = nextDate
                    }
                } else if source.referencePayDate < startOfYear {
                    // If the reference pay date less-than the start of the year, then go
                    // forward to the first pay date of the year.
                    var iterationDate = source.referencePayDate
                    while iterationDate < startOfYear {
                        guard var nextDate = calendar.date(
                            byAdding: .weekOfMonth,
                            value: 2,
                            to: iterationDate
                        ) else {
                            throw Error.invalidDate
                        }
                        guard nextDate < startOfYear else { break }
                        iterationDate = nextDate
                    }
                    guard var nextDate = calendar.date(
                        byAdding: .weekOfMonth,
                        value: 2,
                        to: iterationDate
                    ) else {
                        throw Error.invalidDate
                    }
                    dates.append(nextDate)
                    iterationDate = nextDate
                    while iterationDate < startOfNextYear {
                        guard var nextDate = calendar.date(
                            byAdding: .weekOfMonth,
                            value: 2,
                            to: iterationDate
                        ) else {
                            throw Error.invalidDate
                        }
                        guard nextDate < startOfNextYear else { break }
                        dates.append(nextDate)
                        iterationDate = nextDate
                    }
                } else {
                    // TODO: Handle this
                }
            case .weekly:
                if startOfYear < source.referencePayDate {
                    // If the start of the year is less-than the reference pay date, then go
                    // backward to the first pay date of the year.
                    var iterationDate = firstPayDateOfCurrentYear
                    while startOfYear < iterationDate {
                        guard var previousDate = calendar.date(
                            byAdding: .weekOfMonth,
                            value: -1,
                            to: iterationDate
                        ) else {
                            throw Error.invalidDate
                        }
                        guard previousDate >= startOfYear else { break }
                        iterationDate = previousDate
                    }
                    dates.append(iterationDate)
                    while iterationDate < startOfNextYear {
                        guard var nextDate = calendar.date(
                            byAdding: .weekOfMonth,
                            value: 1,
                            to: iterationDate
                        ) else {
                            throw Error.invalidDate
                        }
                        guard nextDate < startOfNextYear else { break }
                        dates.append(nextDate)
                        iterationDate = nextDate
                    }
                } else if source.referencePayDate < startOfYear {
                    // If the reference pay date less-than the start of the year, then go
                    // forward to the first pay date of the year.
                    var iterationDate = source.referencePayDate
                    while iterationDate < startOfYear {
                        guard var nextDate = calendar.date(
                            byAdding: .weekOfMonth,
                            value: 1,
                            to: iterationDate
                        ) else {
                            throw Error.invalidDate
                        }
                        guard nextDate < startOfYear else { break }
                        iterationDate = nextDate
                    }
                    guard var nextDate = calendar.date(
                        byAdding: .weekOfMonth,
                        value: 1,
                        to: iterationDate
                    ) else {
                        throw Error.invalidDate
                    }
                    dates.append(nextDate)
                    iterationDate = nextDate
                    while iterationDate < startOfNextYear {
                        guard var nextDate = calendar.date(
                            byAdding: .weekOfMonth,
                            value: 1,
                            to: iterationDate
                        ) else {
                            throw Error.invalidDate
                        }
                        guard nextDate < startOfNextYear else { break }
                        dates.append(nextDate)
                        iterationDate = nextDate
                    }
                } else {
                    // TODO: Handle this
                }
            }
            return dates.map { date in
                PayDate(date: date, source: source, uuid: UUID())
            }
        }
        
        @Sendable
        func year(selectedDate: Date, sources: IdentifiedArrayOf<PaySource>) throws -> Year {
            @Dependency(\.date.now) var now
            guard let selectedDateYearInterval = calendar.dateInterval(
                of: .year,
                for: selectedDate
            ) else {
                throw Error.invalidDate
            }
            let startOfYear = selectedDateYearInterval.start
            var combinedPayDates = [PayDate]()
            for source in sources {
                let payDates = try payDates(selectedDate: selectedDate, source: source)
                combinedPayDates.append(contentsOf: payDates)
            }
            // Sort combined pay dates
            let sortedPayDates = combinedPayDates.sorted { lhs, rhs in
                lhs.date < rhs.date
            }
            // Chunk pay dates by month
            let chunkedByMonth = sortedPayDates.chunked { lhs, rhs in
                calendar.isDate(lhs.date, equalTo: rhs.date, toGranularity: .month)
            }
            let months: [Month] = chunkedByMonth.compactMap { chunk in
                guard
                    let startDate = chunk.first?.date,
                    let monthInterval = calendar.dateInterval(of: .month, for: startDate)
                else {
                    return nil
                }
                let isCurrentMonth = calendar.isDate(
                    monthInterval.start,
                    equalTo: now,
                    toGranularity: .month
                )
                return Month(
                    isCurrentMonth: isCurrentMonth,
                    monthStartDate: monthInterval.start,
                    payDates: Array(chunk),
                    uuid: UUID()
                )
            }
            let identifiedMonths = IdentifiedArrayOf<Month>(uniqueElements: months)
            return Year(yearStartDate: startOfYear, months: identifiedMonths, uuid: UUID())
        }
        
        return PayClient(
            nextCoalescedPayDate: { currentDate, sources in
                let currentYear = try year(selectedDate: currentDate, sources: sources)
                guard let currentMonth = (currentYear.months.first { month in month.isCurrentMonth }) else {
                    throw Error.invalidDate
                }
                let currentMonthIndex = currentYear.months.index(id: currentMonth.id)
                if currentMonth.id == currentYear.months.last?.id,
                   (currentDate > currentYear.months.last?.coalescedPayDates.last?.date ?? currentDate) {
                    // The last pay date has passed; calculate first pay date of next year.
                    guard
                        let startOfCurrentYear = calendar.dateInterval(of: .year, for: currentDate)?.start,
                        let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfCurrentYear)
                    else {
                        throw Error.invalidDate
                    }
                    let nextYear = try year(selectedDate: startOfNextYear, sources: sources)
                    guard let firstPayDateOfNextYear = nextYear.months.first?.coalescedPayDates.first else {
                        throw Error.invalidDate
                    }
                    return firstPayDateOfNextYear
                } else {
                    // Calculate next pay date in current year.
                    let allDates = currentYear.months.flatMap(\.coalescedPayDates)
                    let nextPayDate = allDates.first { payDate in
                        calendar
                            .startOfDay(for: payDate.date) >= calendar
                            .startOfDay(for: currentDate)
                    }
                    guard let nextPayDate else { throw Error.invalidDate }
                    return nextPayDate
                }
            },
            year: { selectedDate, sources in
                try year(selectedDate: selectedDate, sources: sources)
            }
        )
    }()
}

extension PayClient: Sendable {}

extension DependencyValues {
    public var payClient: PayClient {
        get { self[PayClient.self] }
        set { self[PayClient.self] = newValue }
    }
}
