import ComposableArchitecture
import Foundation
import Models
import ScheduleCreationFeature
import SharedStateExtensions

@Reducer
public struct ScheduleReducer {
    @Reducer(state: .hashable)
    public enum Destination {
        case scheduleCreation(ScheduleCreationReducer)
    }
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var destination: Destination.State?
        @Shared(.didSetInitialIncomeSchedule) public var didSetInitialIncomeSchedule
        @Shared(.incomeSchedule) public var incomeSchedule
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case onAppear
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .destination(.presented(.scheduleCreation(.tappedDoneButton))):
                state.destination = nil
                return .none
                
            case .destination:
                return .none
                
            case .onAppear:
                if !state.didSetInitialIncomeSchedule {
                    state.destination = .scheduleCreation(ScheduleCreationReducer.State())
                    return .none
                }
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    public init() {}
}
