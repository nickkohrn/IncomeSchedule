import ComposableArchitecture
import Foundation
import Models
import SharedStateExtensions

@Reducer
public struct PaySourceFormReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        public var date: Date
        public var frequency: PayFrequency
        public var name: String
        @Shared(.paySources) public var paySources
        
        public var isFormValid: Bool {
            !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        
        public init(
            date: Date = .now,
            frequency: PayFrequency = .weekly,
            name: String = ""
        ) {
            self.date = date
            self.frequency = frequency
            self.name = name
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(date)
            hasher.combine(frequency)
            hasher.combine(name)
        }
    }
    
    public enum Action: BindableAction {
        public enum Delegate {
            case didCancel
            case didSave
        }
        
        case binding(BindingAction<State>)
        case delegate(Delegate)
        case onAppear
        case selectedDate(Date)
        case setName(String)
        case tappedCancelButton
        case tappedSaveButton
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .delegate:
                return .none
                
            case .onAppear:
                return .none
                
            case .selectedDate(let selectedDate):
                @Dependency(\.calendar) var calendar
                state.date = calendar.startOfDay(for: selectedDate)
                return .none
                
            case .setName(let name):
                state.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
                return .none
                
            case .tappedCancelButton:
                return .send(.delegate(.didCancel))
                
            case .tappedSaveButton:
                @Dependency(\.uuid) var uuid
                let source = PaySource(
                    name: state.name,
                    frequency: state.frequency,
                    referencePayDate: state.date,
                    uuid: uuid()
                )
                state.paySources.insert(source)
                return .send(.delegate(.didSave))
            }
        }
    }
    
    public init() {}
}
