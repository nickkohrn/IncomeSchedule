import ComposableArchitecture
import ScheduleCreationFeature
import SwiftUI

@main
struct IncomeScheduleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ScheduleCreationView(
                    store: StoreOf<ScheduleCreationReducer>(
                        initialState: ScheduleCreationReducer.State(),
                        reducer: {
                            ScheduleCreationReducer()
                        }
                    )
                )
            }
        }
    }
}
