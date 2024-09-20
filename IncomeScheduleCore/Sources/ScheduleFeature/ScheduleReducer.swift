import ComposableArchitecture
import Foundation
import Models
import SharedStateExtensions

@Reducer
public struct ScheduleReducer {
    @ObservableState
    public struct State: Equatable {
        @Shared(.incomeSchedule) public var incomeSchedule
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return .none
            }
        }
    }
    
    public init() {}
}
