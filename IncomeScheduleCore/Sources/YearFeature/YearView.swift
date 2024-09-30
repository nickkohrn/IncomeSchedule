import ComposableArchitecture
import Models
import MonthDetailsFeature
import PaySourceFormFeature
import SwiftUI

public struct YearView: View {
    @Bindable private var store: StoreOf<YearReducer>
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    public init(store: StoreOf<YearReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            if store.paySources.isEmpty {
                ContentUnavailableView {
                    Text("No Pay Sources")
                        .bold()
                } description: {
                    Text("Your pay schedule will be calcualted after you add a pay source.")
                } actions: {
                    Button("Add Pay Source") {
                        store.send(.tappedAddPaySourceButton)
                    }
                }
            } else {
                List {
                    Section {
                        ForEach(store.year.months) { month in
                            Button {
                                store.send(.tappedMonth(month))
                            } label: {
                                LabeledContent {
                                    HStack {
                                        if store.year.maximumPayMonths.contains(month) {
                                            Image(systemName: "arrowtriangle.forward.fill")
                                                .imageScale(.small)
                                                .foregroundStyle(.tertiary)
                                                .scaleEffect(0.75)
                                        }
                                        Text(month.payDates.count.formatted())
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
            }
        }
        .navigationTitle(Text(store.year.yearStartDate.formatted(.dateTime.year())))
        .onAppear { store.send(.onAppear) }
        .toolbar {
            // this is a primary action, so will always be visible
            ToolbarItem(placement: .navigation) {
                Button("Settings", systemImage: "gearshape") {
                    
                }
            }
            ToolbarItemGroup(placement: .secondaryAction) {
                Button {
                    store.send(.tappedAddPaySourceButton)
                } label: {
                    Label("Add Pay Source", systemImage: "plus")
                }

            }
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.monthDetails,
                action: \.destination.monthDetails
            )
        ) { store in
            NavigationStack {
                MonthDetailsView(store: store)
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.paySourceForm,
                action: \.destination.paySourceForm
            )
        ) { store in
            NavigationStack {
                PaySourceFormView(store: store)
            }
        }
    }
}

#if DEBUG
import SharedStateExtensions

#Preview("Populated") {
    @Dependency(\.calendar) var calendar
    @Dependency(\.uuid) var uuid
    @Shared(.paySources) var paySources
    paySources = Set<PaySource>([
        PaySource(
            name: "Atomic Robot",
            frequency: .biWeekly,
            referencePayDate: calendar.date(from: DateComponents(
                year: 2024,
                month: 9,
                day: 20
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

#Preview("Unpopulated") {
    @Shared(.paySources) var paySources
    paySources = []
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
