import ComposableArchitecture
import DesignSystem
import Foundation
import SwiftUI

public struct SettingsView: View {
    @Bindable private var store: StoreOf<SettingsReducer>
    
    public init(store: StoreOf<SettingsReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            Section {
                Toggle(isOn: $store.showMaxPayIndicators.sending(\.toggledShowMaxPayIndicators)) {
                    Label {
                        Text("Pay Indicators")
                    } icon: {
                        Image(systemName: "arrowtriangle.forward.fill")
                    }
                }
            } footer: {
                Text("If enabled, a symbol will indicate months with the highest pay count.")
            }
        }
        .navigationTitle(Text("Settings"))
        .onAppear { store.send(.onAppear) }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                CloseButton { store.send(.tappedCloseButton) }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(
            store: StoreOf<SettingsReducer>(
                initialState: SettingsReducer.State(),
                reducer: { SettingsReducer() }
            )
        )
    }
}
