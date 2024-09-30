import ComposableArchitecture
import Foundation
import Models
import SharedStateExtensions

@Reducer
public struct PaySourceDetailsReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        public let paySource: PaySource
        
        public init(paySource: PaySource) {
            self.paySource = paySource
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(paySource)
        }
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
