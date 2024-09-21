import DesignSystem
import ComposableArchitecture
import Models
import SwiftUI

public struct MonthScheduleDetailsView: View {
    public let store: StoreOf<MonthScheduleDetailsReducer>
    
    public init(store: StoreOf<MonthScheduleDetailsReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List(store.monthSchedule.incomeDates, id: \.self) { date in
            Text(date.formatted(.dateTime.day().weekday(.wide)))
                .foregroundStyle(date < store.startOfCurrentDay ? .secondary : .primary)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                CloseButton { store.send(.tappedCloseButton) }
            }
        }
        .navigationTitle(
            store.monthSchedule.incomeDates.first?.formatted(.dateTime.year().month(.wide)) ?? ""
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MonthScheduleDetailsView(
            store: StoreOf<MonthScheduleDetailsReducer>(
                initialState: MonthScheduleDetailsReducer.State(
                    monthSchedule: MonthSchedule(
                        incomeDates: [
                            .now.addingTimeInterval(-1_234_567),
                            .now
                        ],
                        uuid: UUID()
                    )
                ),
                reducer: {
                    MonthScheduleDetailsReducer()
                }
            )
        )
    }
}
