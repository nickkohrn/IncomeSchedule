import Foundation
import Models
import SwiftUI
import WidgetKit

internal struct CombinedMonthsSystemSmallView: View {
    internal let entry: CombinedMonthsTimelineEntry
    
    internal init(entry: CombinedMonthsTimelineEntry) {
        self.entry = entry
    }
    
    internal var body: some View {
        VStack {
            VStack(alignment: .leading) {
                currentMonthText
                currentMonthDaysText
                paysText
            }
            Spacer()
            Divider()
            Spacer()
            VStack(alignment: .leading) {
                nextMonthText
                nextMonthDaysText
                paysText
            }
        }
        .minimumScaleFactor(0.75)
        .animation(.spring(duration: 0.2), value: entry)
    }
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = entry.spellNumbers ? .spellOut : .decimal
        return formatter
    }
    
    @ViewBuilder
    private var currentMonthText: some View {
        if let date = entry.currentSchedule.firstDate {
            monthText(for: date)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
        }
    }
    
    @ViewBuilder
    private var nextMonthText: some View {
        if let date = entry.nextSchedule.firstDate {
            monthText(for: date)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.caption)
        }
    }
    
    @ViewBuilder
    private var currentMonthDaysText: some View {
        let text = Text(entry.currentSchedule.incomeDates.count as NSNumber, formatter: numberFormatter)
            .font(.title3)
            .fontWeight(.semibold)
        if entry.spellNumbers {
            text
                .contentTransition(.interpolate)
        } else {
            text
                .contentTransition(.numericText())
        }
    }
    
    @ViewBuilder
    private var nextMonthDaysText: some View {
        let text = Text(entry.nextSchedule.incomeDates.count as NSNumber, formatter: numberFormatter)
            .font(.title3)
            .fontWeight(.semibold)
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
            .font(.caption2)
            .textScale(.secondary)
            .fontWidth(.expanded)
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
    CombinedMonthsWidget()
} timeline: {
    CombinedMonthsTimelineEntry(
        date: .now,
        currentSchedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 4))!,
            ],
            uuid: UUID()
        ),
        nextSchedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 4))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
            ],
            uuid: UUID()
        ),
        spellNumbers: false
    )
    CombinedMonthsTimelineEntry(
        date: .now,
        currentSchedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 4))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
            ],
            uuid: UUID()
        ),
        nextSchedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 4))!,
            ],
            uuid: UUID()
        ),
        spellNumbers: false
    )
    CombinedMonthsTimelineEntry(
        date: .now,
        currentSchedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 4))!,
            ],
            uuid: UUID()
        ),
        nextSchedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 4))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
            ],
            uuid: UUID()
        ),
        spellNumbers: true
    )
    CombinedMonthsTimelineEntry(
        date: .now,
        currentSchedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 4))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 2, day: 5))!,
            ],
            uuid: UUID()
        ),
        nextSchedule: MonthSchedule(
            incomeDates: [
                Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 1))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 2))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 3))!,
                Calendar.current.date(from: DateComponents(year: 2024, month: 3, day: 4))!,
            ],
            uuid: UUID()
        ),
        spellNumbers: true
    )
}
