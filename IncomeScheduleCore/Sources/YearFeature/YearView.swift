import ComposableArchitecture
import Models
import MonthScheduleDetailsFeature
import ScheduleCreationFeature
import SwiftUI

public struct YearView: View {
    @Bindable private var store: StoreOf<YearReducer>
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    public init(store: StoreOf<YearReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            Section {
                ForEach(store.year.months) { month in
                    Button {
                        
                    } label: {
                        LabeledContent {
                            HStack {
                                if store.year.maximumPayMonths.contains(month) {
                                    Image(systemName: "arrowtriangle.forward.fill")
                                        .imageScale(.small)
                                        .foregroundStyle(.tertiary)
                                        .scaleEffect(0.75)
                                }
                                Text(month.coalescedPayDates.count.formatted())
                            }
                        } label: {
                            HStack {
                                Text(month.monthStartDate.formatted(
                                    .dateTime.month(
                                        dynamicTypeSize.isAccessibilitySize ? .abbreviated : .wide
                                    )
                                ))
                                if month.isCurrentMonth {
                                    Image(systemName: "circle.fill")
                                        .imageScale(.small)
                                        .foregroundStyle(.tertiary)
                                        .scaleEffect(0.75)
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(Text(store.year.yearStartDate.formatted(.dateTime.year())))
        .onAppear { store.send(.onAppear) }
    }
}

#if DEBUG
import SharedStateExtensions

#Preview {
    @Dependency(\.calendar) var calendar
    @Dependency(\.uuid) var uuid
    @Shared(.paySources) var paySources
    paySources = Set<PaySource>([
        PaySource(
            name: "Atomic Robot",
            frequency: .biWeekly,
            referencePayDate: calendar.date(from: DateComponents(
                year: 2022,
                month: 9,
                day: 2
            ))!,
            uuid: uuid()
        ),
        PaySource(
            name: "Lyft",
            frequency: .weekly,
            referencePayDate: calendar.date(from: DateComponents(
                year: 2024,
                month: 9,
                day: 19
            ))!,
            uuid: uuid()
        )
    ])
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
