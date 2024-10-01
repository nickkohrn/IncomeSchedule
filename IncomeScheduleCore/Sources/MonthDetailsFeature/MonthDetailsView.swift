import DesignSystem
import ComposableArchitecture
import Models
import SwiftUI

public struct MonthDetailsView: View {
    public let store: StoreOf<MonthDetailsReducer>
    
    public init(store: StoreOf<MonthDetailsReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            ForEach(store.month.coalescedPayDates) { payDate in
                Section {
                    ForEach(payDate.sortedSourceNames, id: \.self) { sourceName in
                        Text(sourceName)
                    }
                } header: {
                    Text(payDate.date.formatted(.dateTime.weekday(.wide).day()))
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                CloseButton { store.send(.tappedCloseButton) }
            }
        }
        .navigationTitle(Text(store.month.monthStartDate.formatted(.dateTime.year().month(.wide))))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Dependency(\.calendar) var calendar
    @Dependency(\.date.now) var now
    @Dependency(\.uuid) var uuid
    let paySource = PaySource(
        name: "Atomic Robot",
        frequency: .biWeekly,
        referencePayDate: calendar.date(
            from: DateComponents(
                year: 2024,
                month: 7,
                day: 26
            )
        )!,
        uuid: uuid()
    )
    return NavigationStack {
        MonthDetailsView(
            store: StoreOf<MonthDetailsReducer>(
                initialState: MonthDetailsReducer.State(
                    month: Month(
                        isCurrentMonth: false,
                        monthStartDate: calendar.dateInterval(of: .month, for: now)!.start,
                        payDates: [
                            PayDate(
                                date: calendar.date(
                                    from: DateComponents(
                                        year: 2024,
                                        month: 9,
                                        day: 20
                                    )
                                )!,
                                source: paySource,
                                uuid: uuid()
                            ),
                            PayDate(
                                date: calendar.date(
                                    from: DateComponents(
                                        year: 2024,
                                        month: 9,
                                        day: 6
                                    )
                                )!,
                                source: paySource,
                                uuid: uuid()
                            )
                        ],
                        uuid: uuid()
                    )
                ),
                reducer: { MonthDetailsReducer() }
            )
        )
    }
}
