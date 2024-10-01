import ComposableArchitecture
import DesignSystem
import Foundation
import Models
import PaySourceDetailsFeature
import PaySourceFormFeature
import SwiftUI

public struct PaySourcesView: View {
    @Bindable private var store: StoreOf<PaySourcesReducer>
    
    public init(store: StoreOf<PaySourcesReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            if store.paySources.isEmpty {
                ContentUnavailableView {
                    Label("No Pay Sources", systemImage: "banknote")
                } description: {
                    Text("Pay sources you add will appear here.")
                } actions: {
                    Button("Add Pay Source") {
                        store.send(.tappedAddButton)
                    }
                }
            } else {
                List {
                    ForEach(store.sortedPaySources) { source in
                        Button {
                            store.send(.tappedPaySource(source))
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(source.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(Color.primary)
                                    Text(source.frequency.name)
                                        .font(.caption)
                                        .foregroundStyle(Color.primary.secondary)
                                }
                                Spacer()
                                DisclosureIndicator()
                            }
                        }
                    }
                }
            }
        }
        .animation(.default, value: store.paySources)
        .navigationTitle(Text("Pay Sources"))
        .onAppear { store.send(.onAppear) }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton { store.send(.tappedCloseButton) }
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Add Pay Source", systemImage: "plus") {
                    store.send(.tappedAddButton)
                }
            }
        }
        .navigationDestination(
            item: $store.scope(
                state: \.destination?.paySourceDetails,
                action: \.destination.paySourceDetails
            )
        ) { store in
            PaySourceDetailsView(store: store)
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
import IdentifiedCollections
import SharedStateExtensions

#Preview {
    @Dependency(\.calendar) var calendar
    @Dependency(\.uuid) var uuid
    @Shared(.paySources) var paySources
    paySources = IdentifiedArrayOf<PaySource>(uniqueElements: [
        PaySource(
            name: "Atomic Robot",
            frequency: .biWeekly,
            referencePayDate: calendar.date(from: DateComponents(
                year: 2024,
                month: 9,
                day: 20
            ))!,
            uuid: uuid()
        ),
        PaySource(
            name: "Lyft",
            frequency: .weekly,
            referencePayDate: calendar.date(from: DateComponents(
                year: 2024,
                month: 9,
                day: 19
            ))!,
            uuid: uuid()
        )
    ])
    
    return NavigationStack {
        PaySourcesView(
            store: StoreOf<PaySourcesReducer>(
                initialState: PaySourcesReducer.State(),
                reducer: { PaySourcesReducer() }
            )
        )
    }
}
#endif
