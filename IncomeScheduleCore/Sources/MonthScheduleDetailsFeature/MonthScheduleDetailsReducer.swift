import ComposableArchitecture
import Dependencies
import Foundation
import Models

@Reducer
public struct MonthScheduleDetailsReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        public let monthSchedule: MonthSchedule
        
        public var startOfCurrentDay: Date {
            @Dependency(\.calendar) var calendar
            @Dependency(\.date.now) var now
            return calendar.startOfDay(for: now)
        }
        
        public init(monthSchedule: MonthSchedule) {
            self.monthSchedule = monthSchedule
        }
    }
    
    public enum Action {
        case tappedCloseButton
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .tappedCloseButton:
                return .none
            }
        }
    }
    
    public init() {}
}
