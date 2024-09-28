import ComposableArchitecture
import Models
import SwiftUI

public struct PaySourceFormView: View {
    @Bindable private var store: StoreOf<PaySourceFormReducer>
    
    public init(store: StoreOf<PaySourceFormReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Form {
            Section {
                Text("Add a regular source of income so that your pay schedule can be calculated.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .listRowBackground(Color.clear)
            Section {
                TextField("Name", text: $store.name.sending(\.setName))
            } header: {
                Text("Source")
            } footer: {
                Text("This is the name of the source of pay, such as a company name.")
            }
            Section {
                DatePicker(
                    "Last Pay Date",
                    selection: $store.date.sending(\.selectedDate),
                    displayedComponents: .date
                )
                Picker(
                    "Pay Frequency",
                    selection: $store.frequency
                ) {
                    ForEach(PayFrequency.allCases) { frequency in
                        Text(frequency.name)
                            .tag(frequency)
                    }
                }
            } footer: {
                Text("If you have not yet been paid by this source, select the next date on which you will be paid.")
            }
        }
        .navigationTitle("Pay Source")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { store.send(.tappedCancelButton) }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { store.send(.tappedSaveButton) }
                    .disabled(!store.isFormValid)
            }
        }
    }
}

#Preview {
    NavigationStack {
        PaySourceFormView(
            store: StoreOf<PaySourceFormReducer>(
                initialState: PaySourceFormReducer.State(),
                reducer: { PaySourceFormReducer() }
            )
        )
    }
}
