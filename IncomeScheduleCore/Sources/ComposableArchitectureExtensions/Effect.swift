import ComposableArchitecture
import Foundation

extension Effect {
    public static func calendarDayChanged(perform action: @escaping @autoclosure () -> Action) -> Self {
        .publisher {
            NotificationCenter.default.publisher(for: .NSCalendarDayChanged)
                .map { _ in action() }
        }
    }
}
