import ComposableArchitecture
import Foundation
import SharedStateExtensions

@Reducer
public struct SettingsReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        @Shared(.showMaxPayIndicators) public var showMaxPayIndicators
        
        public init() {}
        
        public func hash(into hasher: inout Hasher) {}
    }
    
    public enum Action: BindableAction {
        public enum Delegate {
            case didClose
        }
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case onAppear
        case tappedCloseButton
        case toggledShowMaxPayIndicators(Bool)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .delegate:
                return .none
                
            case .onAppear:
                return .none
                
            case .tappedCloseButton:
                return .send(.delegate(.didClose))
                
            case .toggledShowMaxPayIndicators(let show):
                state.showMaxPayIndicators = show
                return .none
            }
        }
    }
    
    public init() {}
}
