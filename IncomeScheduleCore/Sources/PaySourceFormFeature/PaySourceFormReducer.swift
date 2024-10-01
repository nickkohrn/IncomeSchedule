import ComposableArchitecture
import Foundation
import Models
import SharedStateExtensions
import Tagged

@Reducer
public struct PaySourceFormReducer {
    @ObservableState
    public struct State: Equatable, Hashable {
        public var date: Date
        public var frequency: PayFrequency
        public var name: String
        public var paySource: PaySource?
        @Shared(.paySources) public var paySources
        
        public var isFormValid: Bool {
            if let paySource {
                @Dependency(\.calendar) var calendar
                let existingDate = calendar.startOfDay(for: paySource.referencePayDate)
                let newDate = calendar.startOfDay(for: date)
                let isDateDifferent = existingDate != newDate
                let isFrequencyDifferent = paySource.frequency != frequency
                let existingName = paySource.name.trimmingCharacters(in: .whitespacesAndNewlines)
                let newName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                let isNameDifferent = existingName != newName
                return isDateDifferent
                || isFrequencyDifferent
                || isNameDifferent
            } else {
                return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
        }
        
        public init(paySource: PaySource?) {
            @Dependency(\.date.now) var now
            self.paySource = paySource
            self.date = paySource?.referencePayDate ?? now
            self.frequency = paySource?.frequency ?? .weekly
            self.name = paySource?.name ?? ""
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(paySource)
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
        Reduce {
 state,
 action in
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
                @Dependency(\.calendar) var calendar
                let date = calendar.startOfDay(for: state.date)
                let name = state.name.trimmingCharacters(in: .whitespacesAndNewlines)
                let frequency = state.frequency
                if let paySource = state.paySource {
                    state.paySources[id: paySource.id] = PaySource(
                        name: name,
                        frequency: frequency,
                        referencePayDate: date,
                        uuid: paySource.uuid
                    )
                } else {
                    @Dependency(\.uuid) var uuid
                    let source = PaySource(
                        name: name,
                        frequency: frequency,
                        referencePayDate: date,
                        uuid: uuid()
                    )
                    state.paySources.append(source)
                }
                return .send(.delegate(.didSave))
            }
        }
    }
    
    public init() {}
}
