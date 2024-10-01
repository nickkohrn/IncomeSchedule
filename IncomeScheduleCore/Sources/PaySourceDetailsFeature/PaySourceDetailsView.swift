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
            if let paySource = store.paySource {
                LabeledContent("Source", value: paySource.name)
                LabeledContent("Frequency", value: paySource.frequency.name)
            }
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
    @Dependency(\.date.now) var now
    @Dependency(\.uuid) var uuid
    let paySource = PaySource(
        name: "Atomic Robot",
        frequency: .biWeekly,
        referencePayDate: calendar.date(
            from: DateComponents(
                year: 2024,
                month: 7,
                day: 26
            )
        )!,
        uuid: uuid()
    )
    NavigationStack {
        PaySourceDetailsView(
            store: StoreOf<PaySourceDetailsReducer>(
                initialState: PaySourceDetailsReducer.State(paySourceID: paySource.id),
                reducer: { PaySourceDetailsReducer() }
            )
        )
    }
}
#endif
