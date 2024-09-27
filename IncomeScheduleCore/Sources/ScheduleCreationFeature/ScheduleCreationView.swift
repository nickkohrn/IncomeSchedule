import ComposableArchitecture
import Models
import SwiftUI

public struct ScheduleCreationView: View {
    @Bindable public var store: StoreOf<ScheduleCreationReducer>
    @State private var inlineTitleOpacity: Double = 0
    @State private var scrollTopEdgeInset: Double = 0
    
    public init(store: StoreOf<ScheduleCreationReducer>) {
        self.store = store
    }
    
    public var body: some View {
        Form {
            Section {
                VStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                        .padding()
                        .background(.red)
                        .clipShape(.circle)
                    Text("Pay Schedule")
                        .font(.title2)
                        .bold()
                        .onGeometryChange(for: Double.self) { proxy in
                            let frame = proxy.frame(in: .scrollView)
                            return min(
                                1,
                                max(
                                    0,
                                    (scrollTopEdgeInset - frame.minY) / frame.height
                                )
                            )
                        } action: { inlineTitleOpacity in
                            self.inlineTitleOpacity = inlineTitleOpacity
                        }
                    Text("Set your pay schedule to calculate the number of pays you will receive per month.")
                        .font(.callout)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding()
            }
            .listSectionSeparator(.hidden)
            Section {
                DatePicker(
                    "Last Pay Date",
                    selection: $store.incomeSchedule.date.sending(\.selectedDate),
                    displayedComponents: .date
                )
                Picker(
                    "Pay Frequency",
                    selection: $store.incomeSchedule.frequency
                ) {
                    ForEach(IncomeFrequency.allCases) { frequency in
                        Text(frequency.name)
                            .tag(frequency)
                    }
                }
            }
        }
        .onScrollGeometryChange(
            for: Double.self,
            of: { geometry in
                geometry.contentOffset.y
            }, action: { _, newValue in
                scrollTopEdgeInset = newValue
            }
        )
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Pay Schedule")
                    .font(.body)
                    .bold()
                    .dynamicTypeSize(.large ... .xxxLarge)
                    .opacity(inlineTitleOpacity)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    store.send(.tappedDoneButton)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ScheduleCreationView(
            store: StoreOf<ScheduleCreationReducer>(
                initialState: ScheduleCreationReducer.State(),
                reducer: {
                    ScheduleCreationReducer()
                }
            )
        )
    }
}
