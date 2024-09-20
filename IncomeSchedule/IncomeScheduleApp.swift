import ComposableArchitecture
import ScheduleFeature
import SwiftUI

@main
struct IncomeScheduleApp: App {
    var body: some Scene {
        WindowGroup {
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
    }
}
