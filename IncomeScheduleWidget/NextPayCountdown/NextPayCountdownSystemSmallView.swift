//import Foundation
//import Models
//import SwiftUI
//import WidgetKit
//
//internal struct NextPayCountdownSystemSmallView: View {
//    internal let entry: NextPayCountdownTimelineEntry
//    
//    internal init(entry: NextPayCountdownTimelineEntry) {
//        self.entry = entry
//    }
//    
//    @ViewBuilder
//    private var dateText: some View {
//        Text(entry.payDate.formatted(.dateTime.month().weekday().day()))
//            .textScale(.secondary)
//            .minimumScaleFactor(0.75)
//            .font(.caption)
//            .foregroundStyle(.secondary)
//            .contentTransition(.interpolate)
//    }
//    
//    @ViewBuilder
//    private var daysText: some View {
//        Text(entry.formattedPayDate(calendar: .current, now: .now))
//            .minimumScaleFactor(0.75)
//            .font(.title3)
//            .fontWeight(.semibold)
//            .contentTransition(.interpolate)
//    }
//    
//    @ViewBuilder
//    private var nextPayText: some View {
//        Text("Next Pay")
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .fontWeight(.medium)
//            .textCase(.uppercase)
//            .textScale(.secondary)
//            .foregroundStyle(Color.accentColor)
//    }
//    
//    internal var body: some View {
//        VStack(alignment: .leading) {
//            nextPayText
//            Spacer()
//            dateText
//            daysText
//        }
//        .animation(.spring(duration: 0.2), value: entry.payDate)
//    }
//}
//
//#Preview(as: .systemSmall) {
//    NextPayCountdownWidget()
//} timeline: {
//    NextPayCountdownTimelineEntry(
//        date: .now,
//        payDate: .now,
//        spellNumbers: false
//    )
//    NextPayCountdownTimelineEntry(
//        date: .now,
//        payDate: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
//        spellNumbers: false
//    )
//    NextPayCountdownTimelineEntry(
//        date: .now,
//        payDate: Calendar.current.date(byAdding: .day, value: 2, to: .now)!,
//        spellNumbers: false
//    )
//    NextPayCountdownTimelineEntry(
//        date: .now,
//        payDate: .now,
//        spellNumbers: true
//    )
//    NextPayCountdownTimelineEntry(
//        date: .now,
//        payDate: Calendar.current.date(byAdding: .day, value: 1, to: .now)!,
//        spellNumbers: true
//    )
//    NextPayCountdownTimelineEntry(
//        date: .now,
//        payDate: Calendar.current.date(byAdding: .day, value: 2, to: .now)!,
//        spellNumbers: true
//    )
//}
