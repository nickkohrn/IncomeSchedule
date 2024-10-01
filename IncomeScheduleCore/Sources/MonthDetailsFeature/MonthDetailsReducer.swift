import ComposableArchitecture
import Dependencies
import Foundation
import Models

@Reducer
public struct MonthDetailsReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        public let month: Month
        
        public init(month: Month) {
            self.month = month
        }
    }
    
    public enum Action {
        public enum Delegate {
            case didClose
        }
        
        case delegate(Delegate)
        case tappedCloseButton
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
                
            case .tappedCloseButton:
                return .send(.delegate(.didClose))
            }
        }
    }
    
    public init() {}
}
