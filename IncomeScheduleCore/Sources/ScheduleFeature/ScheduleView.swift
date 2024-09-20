import ComposableArchitecture
import Models
import SwiftUI

public struct ScheduleView: View {
    @Bindable public var store: StoreOf<ScheduleReducer>
    
    public init(store: StoreOf<ScheduleReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            
        }
    }
}

#Preview {
    NavigationStack {
        ScheduleView(
            store: StoreOf<ScheduleReducer>(
                initialState: ScheduleReducer.State(),
                reducer: {
                    ScheduleReducer()
                }
            )
        )
    }
}
