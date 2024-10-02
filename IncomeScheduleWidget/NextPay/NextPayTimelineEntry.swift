import Models
import WidgetKit

internal struct NextPayTimelineEntry: TimelineEntry {
    internal let date: Date
    internal let payDate: CoalescedPayDate
        
    internal init(date: Date, payDate: CoalescedPayDate) {
        self.date = date
        self.payDate = payDate
    }
}
