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
        List(store.yearSchedule.monthSchedules, id: \.self) { monthSchedule in
            Button {
                store.send(.tappedMonthSchedule(id: monthSchedule.id))
            } label: {
                LabeledContent {
                    Text(monthSchedule.incomeDates.count.formatted())
                } label: {
                    HStack {
                        if store.currentMonthSchedule?.id == monthSchedule.id {
                            Image(systemName: "arrow.forward.circle.fill")
                                .imageScale(.small)
                        }
                        Text(monthSchedule.incomeDates.first?.formatted(.dateTime.month(.wide)) ?? "")
                    }
                }
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                return 0
            }
        }
        .onAppear { store.send(.onAppear) }
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
