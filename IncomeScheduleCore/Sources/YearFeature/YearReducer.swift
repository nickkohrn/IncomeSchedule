import ComposableArchitecture
import Foundation
import Models
import PayClient
import SharedStateExtensions

@Reducer
public struct YearReducer {
    @ObservableState
    public struct State: Equatable {
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
        case onAppear
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return calculateYear(state: &state)
            }
        }
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
