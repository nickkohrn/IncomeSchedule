import ComposableArchitecture
import Foundation
import Models
import SharedStateExtensions

@Reducer
public struct PayScheduleReducer {
    @ObservableState
    public struct State {
        @Shared(.paySources) public var paySources
        public var selectedSourceID: PaySource.ID?
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case selectedPaySource(id: PaySource.ID?)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
                
            case .onAppear:
                return .none
                
            case .selectedPaySource(id: let id):
                state.selectedSourceID = id
                return .none
            }
        }
    }
    
    public init() {}
}
