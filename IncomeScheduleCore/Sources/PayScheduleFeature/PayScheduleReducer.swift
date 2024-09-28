import CalendarClient
import ComposableArchitecture
import Foundation
import Models
import PayScheduleClient
import SharedStateExtensions

@Reducer
public struct PayScheduleReducer {
    @ObservableState
    public struct State {
        @Shared(.paySources) public var paySources
        public var selectedSourceID: PaySource.ID?
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case selectedPaySource(id: PaySource.ID?)
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
                
            case .binding:
                return .none
                
            case .onAppear:
                @Dependency(\.calendar) var calendar
                @Dependency(\.calendarClient) var calendarClient
                @Dependency(\.date.now) var now
                @Dependency(\.payScheduleClient) var payScheduleClient
                do {
                    var monthStartDates = try calendarClient.monthStartDates(forDate: now)
                    //======================================================================
                    #warning("Remove this; this is for debugging")
                    state.selectedSourceID = state.paySources.sources.first?.id
                    //======================================================================
                    // If selected source is non-`nil`, calculate for source
                    // If selected source is `nil`, calculate for all sources
                    if let sourceID = state.selectedSourceID {
                        guard let source = state.paySources.sources[id: sourceID] else {
                            // TODO: Handle this
                            return .none
                        }
                        var yearSchedule = try payScheduleClient.yearSchedule(
                            currentDate: now,
                            paySchedule: source.schedule
                        )
                        for date in monthStartDates {
                            
                        }
                    } else {
                        
                    }
                } catch {
                    // TODO: Handle error
                    print(error)
                }
                return .none
                
            case .selectedPaySource(id: let id):
                state.selectedSourceID = id
                return .none
            }
        }
    }
    
    public init() {}
}
