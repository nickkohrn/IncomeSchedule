import ComposableArchitecture
import Foundation
import Models
import SharedStateExtensions

@Reducer
public struct ScheduleCreationReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        @Shared(.didSetInitialIncomeSchedule) public var didSetInitialIncomeSchedule
        @Shared(.incomeSchedule) public var incomeSchedule
        
        public init() {}
        
        public func hash(into hasher: inout Hasher) {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case selectedDate(Date)
        case tappedDoneButton
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return .none
                
            case .selectedDate(let date):
                @Dependency(\.calendar) var calendar
                state.incomeSchedule.date = calendar.startOfDay(for: date)
                return .none
                
            case .tappedDoneButton:
                state.didSetInitialIncomeSchedule = true
                return .none
            }
        }
    }
    
    public init() {}
}
