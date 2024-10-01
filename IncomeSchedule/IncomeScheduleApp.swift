import ComposableArchitecture
import SwiftUI
import YearFeature

@main
struct IncomeScheduleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                YearView(
                    store: StoreOf<YearReducer>(
                        initialState: YearReducer.State(),
                        reducer: { YearReducer() }
                    )
                )
            }
        }
    }
}
