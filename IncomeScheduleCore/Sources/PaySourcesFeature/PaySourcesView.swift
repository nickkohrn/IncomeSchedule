import ComposableArchitecture
import DesignSystem
import Foundation
import Models
import PaySourceDetailsFeature
import SwiftUI

public struct PaySourcesView: View {
    @Bindable private var store: StoreOf<PaySourcesReducer>
    
    public init(store: StoreOf<PaySourcesReducer>) {
        self.store = store
    }
    
    public var body: some View {
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
        .navigationTitle(Text("Pay Sources"))
        .onAppear { store.send(.onAppear) }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton { store.send(.tappedCloseButton) }
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

    }
}

#if DEBUG
import SharedStateExtensions

#Preview {
    @Dependency(\.calendar) var calendar
    @Dependency(\.uuid) var uuid
    @Shared(.paySources) var paySources
    paySources = Set<PaySource>([
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
