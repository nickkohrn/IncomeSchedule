import Models
import WidgetKit

internal struct NextMonthTimelineEntry: TimelineEntry {
    internal let date: Date
    internal let schedule: MonthSchedule
    internal let spellNumbers: Bool
    
    internal init(
        date: Date,
        schedule: MonthSchedule,
        spellNumbers: Bool
    ) {
        self.date = date
        self.schedule = schedule
        self.spellNumbers = spellNumbers
    }
}
