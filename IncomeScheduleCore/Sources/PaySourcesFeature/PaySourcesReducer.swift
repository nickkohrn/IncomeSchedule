import ComposableArchitecture
import Foundation
import Models
import PaySourceDetailsFeature
import SharedStateExtensions

@Reducer
public struct PaySourcesReducer {
    @Reducer(state: .hashable)
    public enum Destination {
        case paySourceDetails(PaySourceDetailsReducer)
    }
    
    @ObservableState
    public struct State: Equatable, Hashable {
        @Presents public var destination: Destination.State?
        @Shared(.paySources) public var paySources
        
        public var sortedPaySources: [PaySource] {
            paySources.sorted { lhs, rhs in
                lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
            }
        }
        
        public init() {}
        
        public func hash(into hasher: inout Hasher) {}
    }
    
    public enum Action: BindableAction {
        public enum Delegate {
            case didClose
        }
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case tappedCloseButton
        case tappedPaySource(PaySource)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .delegate:
                return .none
                
            case .destination:
                return .none
                
            case .onAppear:
                return .none
                
            case .tappedCloseButton:
                return .send(.delegate(.didClose))
                
            case .tappedPaySource(let paySource):
                state.destination = .paySourceDetails(
                    PaySourceDetailsReducer.State(paySource: paySource)
                )
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    public init() {}
}
