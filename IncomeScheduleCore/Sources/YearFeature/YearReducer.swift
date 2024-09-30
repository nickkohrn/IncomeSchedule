import ComposableArchitecture
import Foundation
import Models
import MonthDetailsFeature
import PayClient
import PaySourceFormFeature
import SharedStateExtensions

@Reducer
public struct YearReducer {
    @Reducer(state: .hashable)
    public enum Destination {
        case monthDetails(MonthDetailsReducer)
        case paySourceForm(PaySourceFormReducer)
    }
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var destination: Destination.State?
        public var selectedDate: Date
        public var year: Year
        @Shared(.paySources) public var paySources
        
        public init(selectedDate: Date = .now) {
            @Dependency(\.uuid) var uuid
            self.selectedDate = selectedDate
            self.year = Year(yearStartDate: selectedDate, months: [], uuid: uuid())
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case tappedAddPaySourceButton
        case tappedMonth(Month)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .destination(.presented(.monthDetails(.delegate(.didClose)))):
                state.destination = nil
                return .none
                
            case .destination(.presented(.paySourceForm(.delegate(.didCancel)))):
                state.destination = nil
                return .none
            
            case .destination(.presented(.paySourceForm(.delegate(.didSave)))):
                state.destination = nil
                return calculateYear(state: &state)
                
            case .destination:
                return .none
                
            case .onAppear:
                return calculateYear(state: &state)
                
            case .tappedAddPaySourceButton:
                state.destination = .paySourceForm(PaySourceFormReducer.State())
                return .none
                
            case .tappedMonth(let month):
                state.destination = .monthDetails(MonthDetailsReducer.State(month: month))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    public init() {}
    
    private func calculateYear(state: inout State) -> Effect<Action> {
        do {
            @Dependency(\.payClient) var payClient
            let year = try payClient.year(
                selectedDate: state.selectedDate,
                sources: state.paySources
            )
            state.year = year
        } catch {
            // TODO: Handle this
            print("ERROR:", error)
        }
        return .none
    }
}
