import ComposableArchitecture
import Models
import SwiftUI

public struct PayScheduleView: View {
    @Bindable private var store: StoreOf<PayScheduleReducer>
    
    public init(store: StoreOf<PayScheduleReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Text(store.paySources.sources.count.formatted())
            .navigationTitle("Pay Schedule")
            .onAppear { store.send(.onAppear) }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    sourcesPicker
                }
            }
    }
    
    @ViewBuilder
    private var allSourcesPicker: some View {
        Picker(
            "All",
            selection: $store.selectedSourceID.sending(
                \.selectedPaySource
            )
        ) {
            Button("All") {
                store.send(.selectedPaySource(id: nil))
            }
            .tag(nil as PaySource.ID?)
        }
    }
    
    @ViewBuilder
    private var honestSourcesPicker: some View {
        Picker(
            "Sources",
            selection: $store.selectedSourceID.sending(
                \.selectedPaySource
            )
        ) {
            ForEach(
                store.paySources.sources.ids,
                id: \.self
            ) { id in
                if let source = store.paySources.sources[id: id] {
                    Text(source.name)
                        .tag(id)
                }
            }
        }
    }
    
    @ViewBuilder
    private var sourcesPicker: some View {
        Menu {
            allSourcesPicker
            honestSourcesPicker
        } label: {
            Text("Sources")
        }
    }
}

#Preview {
    @Shared(.paySources) var paySources = PaySources(sources: [])
    paySources = PaySources(
        sources: [
            PaySource(
                name: "Atomic Robot",
                schedule: PaySchedule(
                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 20))!,
                    frequency: .biWeekly
                ),
                uuid: UUID()
            ),
            PaySource(
                name: "Apple",
                schedule: PaySchedule(
                    date: Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 15))!,
                    frequency: .monthly
                ),
                uuid: UUID()
            )
        ]
    )
    return NavigationStack {
        PayScheduleView(
            store: StoreOf<PayScheduleReducer>(
                initialState: PayScheduleReducer.State(),
                reducer: { PayScheduleReducer() }
            )
        )
    }
}
