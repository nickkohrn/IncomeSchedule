import ComposableArchitecture
import DesignSystem
import Foundation
import Models
import PaySourceFormFeature
import SwiftUI

public struct PaySourceDetailsView: View {
    @Bindable private var store: StoreOf<PaySourceDetailsReducer>
    
    public init(store: StoreOf<PaySourceDetailsReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            LabeledContent("Source", value: store.paySource.name)
            LabeledContent("Frequency", value: store.paySource.frequency.name)
        }
        .navigationTitle(Text("Pay Source"))
        .onAppear { store.send(.onAppear) }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") { store.send(.tappedEditButton) }
            }
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.paySourceForm,
                action: \.destination.paySourceForm
            )
        ) { store in
            NavigationStack {
                PaySourceFormView(store: store)
            }
        }
    }
}

#if DEBUG
import SharedStateExtensions

#Preview {
    @Dependency(\.calendar) var calendar
    @Dependency(\.uuid) var uuid
    NavigationStack {
        PaySourceDetailsView(
            store: StoreOf<PaySourceDetailsReducer>(
                initialState: PaySourceDetailsReducer.State(
                    paySource: PaySource(
                        name: "Atomic Robot",
                        frequency: .biWeekly,
                        referencePayDate: calendar.date(from: DateComponents(
                            year: 2024,
                            month: 9,
                            day: 20
                        ))!,
                        uuid: uuid()
                    )
                ),
                reducer: { PaySourceDetailsReducer() }
            )
        )
    }
}
#endif
