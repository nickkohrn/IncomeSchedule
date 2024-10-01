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
        VStack {
            if let paySource = store.paySource {
                List {
                    LabeledContent("Source", value: paySource.name)
                    LabeledContent("Frequency", value: paySource.frequency.name)
                }
            } else {
                ContentUnavailableView(
                    "Pay Source Unavailable",
                    systemImage: "questionmark.circle",
                    description: Text("There was a problem retrieving your pay source")
                )
            }
        }
        .navigationTitle(Text("Pay Source"))
        .onAppear { store.send(.onAppear) }
        .toolbar {
            if let _ = store.paySource {
                ToolbarItem(placement: .primaryAction) {
                    Button("Edit") { store.send(.tappedEditButton) }
                }
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button("Delete", systemImage: "trash") {
                        store.send(.tappedDeleteButton)
                    }
                    Spacer()
                }
            }
        }
        .confirmationDialog($store.scope(
            state: \.destination?.confirmationDialog,
            action: \.destination.confirmationDialog
        ))
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
import Dependencies
import SharedStateExtensions

#Preview("Populated") {
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

#Preview(
    "Unpopulated",
    traits: .dependencies({ dependencies in
        dependencies.uuid = .constant(UUID(1))
    })
) {
    @Dependency(\.uuid) var uuid
    return NavigationStack {
        PaySourceDetailsView(
            store: StoreOf<PaySourceDetailsReducer>(
                initialState: PaySourceDetailsReducer.State(paySourceID: PaySource.ID(uuid())),
                reducer: { PaySourceDetailsReducer() }
            )
        )
    }
}
#endif
