import ComposableArchitecture
import Models
import MonthScheduleDetailsFeature
import ScheduleCreationFeature
import SwiftUI

public struct YearView: View {
    @Bindable public var store: StoreOf<YearReducer>
    
    public init(store: StoreOf<YearReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            Section {
                ForEach(store.year.months) { month in
                    Text(month.monthStartDate.formatted(.dateTime.month(.wide)))
                }
            } header: {
                Text(store.year.yearStartDate.formatted(.dateTime.year()))
            }
            .headerProminence(.increased)
        }
        .onAppear { store.send(.onAppear) }
    }
}

#if DEBUG
import SharedStateExtensions

#Preview {
    @Dependency(\.calendar) var calendar
    @Dependency(\.uuid) var uuid
    @Shared(.paySources) var paySources
    paySources = Set<PaySource>(
        arrayLiteral: PaySource(
            name: "Atomic Robot",
            frequency: .biWeekly,
            referencePayDate: calendar.date(from: DateComponents(
                year: 2022,
                month: 9,
                day: 2
            ))!,
            uuid: uuid()
        )
    )
    return NavigationStack {
        YearView(
            store: StoreOf<YearReducer>(
                initialState: YearReducer.State(),
                reducer: { YearReducer() }
            )
        )
    }
}
#endif
