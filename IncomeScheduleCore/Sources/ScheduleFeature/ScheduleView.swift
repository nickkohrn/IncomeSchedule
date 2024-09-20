import ComposableArchitecture
import Models
import ScheduleCreationFeature
import SwiftUI

public struct ScheduleView: View {
    @Bindable public var store: StoreOf<ScheduleReducer>
    
    public init(store: StoreOf<ScheduleReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            
        }
        .onAppear { store.send(.onAppear) }
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
