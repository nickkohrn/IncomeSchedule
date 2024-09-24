import ComposableArchitecture
import Foundation
import Models
import MonthScheduleDetailsFeature
import ScheduleClient
import ScheduleCreationFeature
import SharedStateExtensions

@Reducer
public struct ScheduleReducer {
    @Reducer(state: .hashable)
    public enum Destination {
        case monthScheduleDetails(MonthScheduleDetailsReducer)
        case scheduleCreation(ScheduleCreationReducer)
    }
    
    @ObservableState
    public struct State: Equatable {
        @Presents public var destination: Destination.State?
        @Shared(.didSetInitialIncomeSchedule) public var didSetInitialIncomeSchedule
        @Shared(.incomeSchedule) public var incomeSchedule
        public var selectedDate: Date
        public var yearSchedule: YearSchedule
        
        public var currentMonthSchedule: MonthSchedule? {
            @Dependency(\.calendar) var calendar
            @Dependency(\.date.now) var now
            return yearSchedule.monthSchedules.first(where: { monthSchedule in
                monthSchedule.incomeDates.contains(where: { date in
                    calendar.isDate(date, equalTo: now, toGranularity: .month)
                })
            })
        }
        
        public var isCurrentYearSchedule: Bool {
            @Dependency(\.calendar) var calendar
            @Dependency(\.date.now) var now
            guard let firstIncomeDate = yearSchedule.monthSchedules.flatMap(\.incomeDates).first else {
                return false
            }
            return calendar.isDate(firstIncomeDate, equalTo: now, toGranularity: .year)
        }
        
        public var nextButtonTitle: String {
            @Dependency(\.calendar) var calendar
            guard
                let startOfCurrentYear = calendar.dateInterval(of: .year, for: selectedDate)?.start,
                let startOfNextYear = calendar.date(byAdding: .year, value: 1, to: startOfCurrentYear)
            else {
                // TODO: Handle this
                return "Next"
            }
            return startOfNextYear.formatted(.dateTime.year())
        }
        
        public var previousButtonTitle: String {
            @Dependency(\.calendar) var calendar
            guard
                let startOfCurrentYear = calendar.dateInterval(of: .year, for: selectedDate)?.start,
                let startOfPreviousYear = calendar.date(byAdding: .year, value: -1, to: startOfCurrentYear)
            else {
                // TODO: Handle this
                return "Previous"
            }
            return startOfPreviousYear.formatted(.dateTime.year())
        }
        
        public var sectionTitle: String {
            yearSchedule.monthSchedules.first?.incomeDates.first?.formatted(.dateTime.year()) ?? ""
        }
        
        public init(selectedDate: Date = .now) {
            @Dependency(\.uuid) var uuid
            self.selectedDate = selectedDate
            self.yearSchedule = YearSchedule(monthSchedules: [], uuid: uuid())
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case destination(PresentationAction<Destination.Action>)
        case onAppear
        case tappedCurrentYearButton
        case tappedMonthSchedule(id: MonthSchedule.ID)
        case tappedNextYearButton
        case tappedPreviousYearButton
        case tappedSettingsButton
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .destination(.presented(.monthScheduleDetails(.tappedCloseButton))):
                state.destination = nil
                return .none
                
            case .destination(.presented(.scheduleCreation(.tappedDoneButton))):
                state.destination = nil
                return calculateSchedule(state: &state)
                
            case .destination:
                return .none
                
            case .onAppear:
                if !state.didSetInitialIncomeSchedule {
                    state.destination = .scheduleCreation(ScheduleCreationReducer.State())
                    return .none
                }
                return calculateSchedule(state: &state)
                
            case .tappedCurrentYearButton:
                @Dependency(\.calendar) var calendar
                @Dependency(\.date.now) var now
                guard let startOfCurrentYear = calendar.dateInterval(of: .year, for: now)?.start else {
                    // TODO: Handle this
                    return .none
                }
                let startOfSelectedDate = calendar.startOfDay(for: state.selectedDate)
                guard !calendar.isDate(startOfCurrentYear, inSameDayAs: startOfSelectedDate) else {
                    return .none
                }
                state.selectedDate = startOfCurrentYear
                return calculateSchedule(state: &state)
                
            case .tappedMonthSchedule(let id):
                guard let monthSchedule = state.yearSchedule.monthSchedules[id: id] else {
                    // TODO: Handle this
                    return .none
                }
                state.destination = .monthScheduleDetails(
                    MonthScheduleDetailsReducer.State(monthSchedule: monthSchedule)
                )
                return .none
                
            case .tappedNextYearButton:
                @Dependency(\.calendar) var calendar
                guard
                    let nextYear = calendar.date(byAdding: .year, value: 1, to: state.selectedDate),
                    let startOfNextYear = calendar.dateInterval(of: .year, for: nextYear)?.start
                else {
                    // TODO: Handle this
                    return .none
                }
                state.selectedDate = startOfNextYear
                return calculateSchedule(state: &state)
                
            case .tappedPreviousYearButton:
                @Dependency(\.calendar) var calendar
                guard
                    let nextYear = calendar.date(byAdding: .year, value: -1, to: state.selectedDate),
                    let startOfNextYear = calendar.dateInterval(of: .year, for: nextYear)?.start
                else {
                    // TODO: Handle this
                    return .none
                }
                state.selectedDate = startOfNextYear
                return calculateSchedule(state: &state)
                
            case .tappedSettingsButton:
                state.destination = .scheduleCreation(ScheduleCreationReducer.State())
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
    
    public init() {}
    
    private func calculateSchedule(state: inout State) -> Effect<Action> {
        do {
            @Dependency(\.scheduleClient) var scheduleClient
            @Dependency(\.date.now) var now
            let yearSchedule = try scheduleClient.yearSchedule(
                currentDate: state.selectedDate,
                incomeSchedule: state.incomeSchedule
            )
            state.yearSchedule = yearSchedule
        } catch {
            // TODO: Handle error
            print(error)
        }
        return .none
    }
}
