import ComposableArchitecture
import Foundation
import Models
import MonthDetailsFeature
import PayClient
import PaySourceFormFeature
import PaySourcesFeature
import SharedStateExtensions
import Tagged

@Reducer
public struct YearReducer {
    @Reducer(state: .hashable)
    public enum Destination {
        case monthDetails(MonthDetailsReducer)
        case paySourceForm(PaySourceFormReducer)
        case paySources(PaySourcesReducer)
    }
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var destination: Destination.State?
        public var selectedDate: Date
        public var year: Year
        @Shared(.paySources) public var paySources
        
        public var currentMonth: Month? {
            @Dependency(\.calendar) var calendar
            @Dependency(\.date.now) var now
            return year.months.first(where: { month in
                month.payDates.contains(where: { payDate in
                    calendar.isDate(payDate.date, equalTo: now, toGranularity: .month)
                })
            })
        }
        
        public var isCurrentYear: Bool {
            @Dependency(\.calendar) var calendar
            @Dependency(\.date.now) var now
            guard let firstDate = year.months.first?.monthStartDate else { return false }
            return calendar.isDate(firstDate, equalTo: now, toGranularity: .year)
        }
        
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
        case paySourcesUpdated(IdentifiedArrayOf<PaySource>)
        case tappedAddPaySourceButton
        case tappedMonthButton(Month)
        case tappedViewPaySourcesButton
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
                
            case .destination(.presented(.paySources(.delegate(.didClose)))):
                state.destination = nil
                return .none
                
            case .destination:
                return .none
                
            case .onAppear:
                return .merge(
                    calculateYear(state: &state),
                    .publisher {
                        state.$paySources.publisher.map { updatedSources in
                            Action.paySourcesUpdated(updatedSources)
                        }
                    }
                )
                
            case .paySourcesUpdated:
                return calculateYear(state: &state)
                
            case .tappedAddPaySourceButton:
                state.destination = .paySourceForm(PaySourceFormReducer.State(paySource: nil))
                return .none
                
            case .tappedMonthButton(let month):
                state.destination = .monthDetails(MonthDetailsReducer.State(month: month))
                return .none
                
            case .tappedViewPaySourcesButton:
                state.destination = .paySources(PaySourcesReducer.State())
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
