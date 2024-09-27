import Foundation
import Models
import SwiftUI
import WidgetKit

internal struct NextMonthSystemSmallView: View {
    internal let entry: NextMonthTimelineEntry
    
    internal init(entry: NextMonthTimelineEntry) {
        self.entry = entry
    }
    
    internal var body: some View {
        VStack(alignment: .leading) {
            if let date = entry.schedule.firstDate {
                monthText(for: date)
                nextMonthText
            }
            Spacer()
            daysText
            paysText
        }
        .animation(.spring(duration: 0.2), value: entry.schedule)
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = entry.spellNumbers ? .spellOut : .decimal
        return formatter
    }
    
    @ViewBuilder
    private var daysText: some View {
        let text = Text(entry.schedule.incomeDates.count as NSNumber, formatter: numberFormatter)
            .font(.title).fontWeight(.semibold)
        if entry.spellNumbers {
            text
                .contentTransition(.interpolate)
        } else {
            text
                .contentTransition(.numericText())
        }
    }
    
    @ViewBuilder
    private var paysText: some View {
        Text("PAYS")
            .textScale(.secondary)
            .fontWidth(.expanded)
            .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private var nextMonthText: some View {
        Text("next month")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    
    @ViewBuilder
    private func monthText(for date: Date) -> some View {
        Text(date.formatted(.dateTime.month(.wide)))
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(.medium)
            .textCase(.uppercase)
            .textScale(.secondary)
            .foregroundStyle(Color.accentColor)
            .contentTransition(.interpolate)
    }
}

#Preview(
    "Numeric",
    as: .systemSmall
) {
    NextMonthWidget()
} timeline: {
    NextMonthTimelineEntry(
        date: .now,
        schedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 4))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 5))!,
            ],
            uuid: UUID()
        ),
        spellNumbers: false
    )
    NextMonthTimelineEntry(
        date: .now,
        schedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 4))!
            ],
            uuid: UUID()
        ),
        spellNumbers: false
    )
}

#Preview(
    "Spelled",
    as: .systemSmall
) {
    NextMonthWidget()
} timeline: {
    NextMonthTimelineEntry(
        date: .now,
        schedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 4))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 5))!,
            ],
            uuid: UUID()
        ),
        spellNumbers: true
    )
    NextMonthTimelineEntry(
        date: .now,
        schedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 4))!
            ],
            uuid: UUID()
        ),
        spellNumbers: true
    )
}
