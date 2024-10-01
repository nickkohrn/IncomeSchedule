import ComposableArchitecture
import Models
import MonthDetailsFeature
import PaySourceFormFeature
import PaySourcesFeature
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
                    if store.isCurrentYear, let currentMonth = store.currentMonth {
                        Section {
                            Button {
                                store.send(.tappedMonthButton(currentMonth))
                            } label: {
                                LabeledContent {
                                    Text(currentMonth.coalescedPayDates.count.formatted())
                                } label: {
                                    Text(currentMonth.monthStartDate.formatted(
                                        .dateTime.month(
                                            dynamicTypeSize.isAccessibilitySize ? .abbreviated : .wide
                                        )
                                    ))
                                }
                            }
                        } header: {
                            Text("This Month")
                        }
                    }
                    Section {
                        ForEach(store.year.months) { month in
                            Button {
                                store.send(.tappedMonthButton(month))
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
                                    }
                                }
                            }
                        }
                    } header: {
                        if store.isCurrentYear {
                            Text("This Year")
                        } else {
                            Text(store.year.yearStartDate.formatted(.dateTime.year()))
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("Pay Schedule"))
        .onAppear { store.send(.onAppear) }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button("Settings", systemImage: "gearshape") {
                    
                }
            }
            ToolbarItemGroup(placement: .secondaryAction) {
                Button {
                    store.send(.tappedViewPaySourcesButton)
                } label: {
                    Label("View Pay Sources", systemImage: "eye")
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
        .sheet(
            item: $store.scope(
                state: \.destination?.paySources,
                action: \.destination.paySources
            )
        ) { store in
            NavigationStack {
                PaySourcesView(store: store)
            }
        }
    }
}

#if DEBUG
import IdentifiedCollections
import SharedStateExtensions

#Preview("Populated") {
    @Dependency(\.calendar) var calendar
    @Dependency(\.uuid) var uuid
    @Shared(.paySources) var paySources
    paySources = IdentifiedArrayOf<PaySource>(uniqueElements: [
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
