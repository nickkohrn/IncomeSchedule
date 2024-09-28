import ComposableArchitecture
import Foundation
import Models
import SharedStateExtensions

@Reducer
public struct PaySourcesReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        @Shared(.paySources) public var paySources
        
        public init() {}
        
        public func hash(into hasher: inout Hasher) {}
    }
    
    public enum Action {
        case onAppear
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .none
            }
        }
    }
    
    public init() {}
}
