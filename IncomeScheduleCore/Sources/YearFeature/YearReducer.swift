import ComposableArchitecture
import ComposableArchitectureExtensions
import Foundation
import Models
import MonthDetailsFeature
import PayClient
import PaySourceFormFeature
import PaySourcesFeature
import SettingsFeature
import SharedStateExtensions
import SwiftUI
import Tagged

@Reducer
public struct YearReducer {
    @Reducer(state: .hashable)
    public enum Destination {
        case monthDetails(MonthDetailsReducer)
        case paySourceForm(PaySourceFormReducer)
        case paySources(PaySourcesReducer)
        case settings(SettingsReducer)
    }
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var destination: Destination.State?
        public var selectedDate: Date
        public var year: Year
        @Shared(.paySources) public var paySources
        @Shared(.showCurrentMonthProminently) public var showCurrentMonthProminently
        @Shared(.showMaxPayIndicators) public var showMaxPayIndicators
        
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
        case observedCalendarDayChanged
        case onAppear
        case paySourcesUpdated(IdentifiedArrayOf<PaySource>)
        case scenePhaseDidChange(old: ScenePhase, new: ScenePhase)
        case tappedAddPaySourceButton
        case tappedMonthButton(Month)
        case tappedSettingsButton
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
                
            case .destination(.presented(.settings(.delegate(.didClose)))):
                state.destination = nil
                return .none
                
            case .destination:
                return .none
                
            case .observedCalendarDayChanged:
                return calculateYear(state: &state)
                
            case .onAppear:
                return .merge(
                    .publisher {
                        state.$paySources.publisher.map { updatedSources in
                            Action.paySourcesUpdated(updatedSources)
                        }
                    },
                    Effect.calendarDayChanged(perform: Action.observedCalendarDayChanged)
                )
                
            case .paySourcesUpdated:
                return calculateYear(state: &state)
                
            case .scenePhaseDidChange(old: let old, new: let new):
                guard old != new, new == .active else { return .none }
                return calculateYear(state: &state)
                
            case .tappedAddPaySourceButton:
                state.destination = .paySourceForm(PaySourceFormReducer.State(paySource: nil))
                return .none
                
            case .tappedMonthButton(let month):
                state.destination = .monthDetails(MonthDetailsReducer.State(month: month))
                return .none
                
            case .tappedSettingsButton:
                state.destination = .settings(SettingsReducer.State())
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
