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
        case confirmationDialog(
            ConfirmationDialogState<PaySourceDetailsReducer.Action.ConfirmationDialog>
        )
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
        @CasePathable
        public enum ConfirmationDialog: Equatable {
            case tappedCancelButton
            case tappedDeleteButton
        }
        
        public enum Delegate {
            case deletePaySource(PaySource.ID)
        }
        
        case delegate(Delegate)
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case tappedDeleteButton
        case tappedEditButton
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .delegate:
                return .none
                
            case .destination(.presented(.confirmationDialog(.tappedDeleteButton))):
                state.destination = nil
                return .run { [paySourceID = state.paySourceID] send in
                    @Dependency(\.continuousClock) var clock
                    try? await clock.sleep(for: .seconds(0.1))
                    await send(.delegate(.deletePaySource(paySourceID)))
                }
                
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
                
            case .tappedDeleteButton:
                guard let paySource = state.paySource else { return .none }
                state.destination =
                    .confirmationDialog(
                        ConfirmationDialogState<Action.ConfirmationDialog>(
                            titleVisibility: .automatic,
                            title: {
                                TextState("Delete \(paySource.name)")
                            },
                            actions: {
                                ButtonState(
                                    role: .cancel,
                                    action: .tappedCancelButton
                                ) {
                                    TextState("Cancel")
                                }
                                ButtonState(
                                    role: .destructive,
                                    action: .tappedDeleteButton
                                ) {
                                    TextState("Delete")
                                }
                            },
                            message: {
                                TextState("Are you sure you want to delete \(paySource.name)?")
                            }
                        )
                    )
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
