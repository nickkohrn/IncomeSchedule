import ComposableArchitecture
import Models
import SwiftUI

public struct PaySourcesView: View {
    public let store: StoreOf<PaySourcesReducer>
    
    public init(store: StoreOf<PaySourcesReducer>) {
        self.store = store
    }
    
    public var body: some View {
        List {
            
        }
        .navigationTitle("Pay Sources")
    }
}

#Preview {
    NavigationStack {
        PaySourcesView(
            store: StoreOf<PaySourcesReducer>(
                initialState: PaySourcesReducer.State(),
                reducer: {
                    PaySourcesReducer()
                }
            )
        )
    }
}
