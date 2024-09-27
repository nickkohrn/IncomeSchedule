import SwiftUI
import WidgetKit

@main
internal struct IncomeScheduleWidgetBundle: WidgetBundle {
    internal var body: some Widget {
        CurrentMonthWidget()
        NextMonthWidget()
        CombinedMonthsWidget()
        NextPayCountdownWidget()
    }
}
