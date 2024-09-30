import ComposableArchitecture
import Foundation
import Models
import PaySourceFormFeature
import SharedStateExtensions

@Reducer
public struct PaySourceDetailsReducer {
    @Reducer(state: .hashable)
    public enum Destination {
        case paySourceForm(PaySourceFormReducer)
    }
    
    @ObservableState
    public struct State: Equatable, Hashable {
        @Presents public var destination: Destination.State?
        public let paySource: PaySource
        
        public init(paySource: PaySource) {
            self.paySource = paySource
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(paySource)
        }
    }
    
    public enum Action {
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case tappedEditButton
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.paySourceForm(.delegate(.didCancel)))):
                state.destination = nil
                return .none
                
            case .destination(.presented(.paySourceForm(.delegate(.didSave)))):
                state.destination = nil
                return .none
                
            case .destination:
                return .none
                
            case .onAppear:
                return .none
                
            case .tappedEditButton:
                state.destination = .paySourceForm(
                    PaySourceFormReducer.State(paySource: state.paySource)
                )
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    public init() {}
}
