import ComposableArchitecture
import Foundation
import Models
import SharedStateExtensions

@Reducer
public struct PaySourcesReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        @Shared(.paySources) public var paySources
        
        public var sortedPaySources: [PaySource] {
            paySources.sorted { lhs, rhs in
                lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
            }
        }
        
        public init() {}
        
        public func hash(into hasher: inout Hasher) {}
    }
    
    public enum Action {
        public enum Delegate {
            case didClose
        }
        
        case delegate(Delegate)
        case onAppear
        case tappedCloseButton
        case tappedPaySource(PaySource)
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
                
            case .onAppear:
                return .none
                
            case .tappedCloseButton:
                return .send(.delegate(.didClose))
                
            case .tappedPaySource(let paySource):
                return .none
            }
        }
    }
    
    public init() {}
}
