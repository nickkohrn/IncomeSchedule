import ComposableArchitecture
import Models
import MonthScheduleDetailsFeature
import ScheduleCreationFeature
import SwiftUI

public struct ScheduleView: View {
    @Bindable public var store: StoreOf<ScheduleReducer>
    
    public init(store: StoreOf<ScheduleReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            Section {
                ForEach(store.yearSchedule.monthSchedules, id: \.self) { monthSchedule in
                    Button {
                        store.send(.tappedMonthSchedule(id: monthSchedule.id))
                    } label: {
                        LabeledContent {
                            Text(monthSchedule.incomeDates.count.formatted())
                        } label: {
                            HStack {
                                Text(
                                    monthSchedule.incomeDates.first?.formatted(.dateTime.month(.wide)) ?? ""
                                )
                                if store.currentMonthSchedule?.id == monthSchedule.id {
                                    Image(systemName: "circle.fill")
                                        .font(.caption2)
                                        .foregroundStyle(Color.orange.secondary)
                                }
                            }
                        }
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        return 0
                    }
                }
            } header: {
                Text(store.sectionTitle)
            }
            .headerProminence(.increased)
        }
        .navigationTitle("Pay Schedule")
        .onAppear { store.send(.onAppear) }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Button(action: {
                    store.send(.tappedPreviousYearButton)
                }) {
                    HStack {
                        Image(systemName: "chevron.backward")
                        Text(store.previousButtonTitle)
                    }
                }
                Spacer()
                Button(action: {
                    store.send(.tappedCurrentYearButton)
                }) {
                    Text("Today")
                }
                Spacer()
                Button(action: {
                    store.send(.tappedNextYearButton)
                }) {
                    HStack {
                        Text(store.nextButtonTitle)
                        Image(systemName: "chevron.forward")
                    }
                }
            }
            .monospacedDigit()
            .padding()
            .background(Material.bar)
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    store.send(.tappedSettingsButton)
                }) {
                    Label("Settings", systemImage: "gearshape")
                }
            }
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.monthScheduleDetails,
                action: \.destination.monthScheduleDetails
            )
        ) { store in
            NavigationStack {
                MonthScheduleDetailsView(store: store)
            }
            .presentationDetents([.medium, .large])
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.scheduleCreation,
                action: \.destination.scheduleCreation
            )
        ) { store in
            NavigationStack {
                ScheduleCreationView(store: store)
            }
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    NavigationStack {
        ScheduleView(
            store: StoreOf<ScheduleReducer>(
                initialState: ScheduleReducer.State(),
                reducer: { ScheduleReducer() }
            )
        )
    }
}
