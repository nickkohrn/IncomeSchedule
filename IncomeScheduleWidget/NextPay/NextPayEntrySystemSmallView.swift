import Foundation
import Models
import SwiftUI
import WidgetKit

internal struct NextPayEntrySystemSmallView: View {
    internal let entry: NextPayTimelineEntry
    
    internal init(entry: NextPayTimelineEntry) {
        self.entry = entry
    }
    
    internal var body: some View {
        VStack(alignment: .leading) {
            Text("Next Pay")
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text(entry.payDate.formatted(.daysUntil))
        }
        .animation(.spring(duration: 0.2), value: entry.payDate)
    }
}

#Preview(as: .systemSmall) {
    NextPayWidget()
} timeline: {
    NextPayTimelineEntry(
        date: .now,
        payDate: CoalescedPayDate(
            date: .now,
            sources: [
                PaySource(
                    name: "My Job",
                    frequency: .biWeekly,
                    referencePayDate: .now,
                    uuid: UUID()
                )
            ],
            uuid: UUID()
        )
    )
}
