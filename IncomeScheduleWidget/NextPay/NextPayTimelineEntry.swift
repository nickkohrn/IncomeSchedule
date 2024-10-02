import Models
import WidgetKit

internal struct NextPayTimelineEntry: TimelineEntry {
    internal let date: Date
    internal let payDate: Date
    
    internal init(
        date: Date,
        payDate: Date
    ) {
        self.date = date
        self.payDate = payDate
    }
}
