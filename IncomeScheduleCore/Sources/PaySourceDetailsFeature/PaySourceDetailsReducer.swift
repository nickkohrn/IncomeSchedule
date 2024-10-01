import ComposableArchitecture
import Foundation
import Models
import PaySourceFormFeature
import SharedStateExtensions
import Tagged

@Reducer
public struct PaySourceDetailsReducer {
    @Reducer(state: .hashable)
    public enum Destination {
        case paySourceForm(PaySourceFormReducer)
    }
    
    @ObservableState
    public struct State: Equatable, Hashable {
        @Presents public var destination: Destination.State?
        @Shared(.paySources) public var paySources
        public var paySourceID: PaySource.ID
        
        public var paySource: PaySource? {
            paySources[id: paySourceID]
        }
        
        public init(paySourceID: PaySource.ID) {
            self.paySourceID = paySourceID
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(destination)
            hasher.combine(paySourceID)
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
