import Models
import WidgetKit

internal struct CombinedMonthsTimelineEntry: TimelineEntry {
    internal let date: Date
    internal let currentSchedule: MonthSchedule
    internal let nextSchedule: MonthSchedule
    internal let spellNumbers: Bool
    
    internal init(
        date: Date,
        currentSchedule: MonthSchedule,
        nextSchedule: MonthSchedule,
        spellNumbers: Bool
    ) {
        self.date = date
        self.currentSchedule = currentSchedule
        self.nextSchedule = nextSchedule
        self.spellNumbers = spellNumbers
    }
}

extension CombinedMonthsTimelineEntry: Equatable {}
