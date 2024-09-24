import Models
import WidgetKit

internal struct NextPayCountdownTimelineEntry: TimelineEntry {
    internal let date: Date
    internal let payDate: Date
    internal let spellNumbers: Bool
    
    internal init(
        date: Date,
        payDate: Date,
        spellNumbers: Bool
    ) {
        self.date = date
        self.payDate = payDate
        self.spellNumbers = spellNumbers
    }
    
    internal func formattedPayDate(calendar: Calendar, now: Date) -> String {
        let startOfToday = calendar.startOfDay(for: now)
        let startOfPayDate = calendar.startOfDay(for: payDate)
        if calendar.isDateInToday(startOfPayDate)
            || calendar.isDateInTomorrow(payDate) {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            formatter.doesRelativeDateFormatting = true
            formatter.formattingContext = .standalone
            return formatter.string(from: startOfPayDate).localizedLowercase
        } else {
            let dateComponents = calendar.dateComponents(
                [.day],
                from: startOfToday,
                to: startOfPayDate
            )
            let formatter = DateComponentsFormatter()
            formatter.calendar = calendar
            formatter.formattingContext = .standalone
            formatter.unitsStyle = spellNumbers ? .spellOut : .full
            return formatter.string(from: dateComponents)?.localizedLowercase ?? ""
        }
    }
}
