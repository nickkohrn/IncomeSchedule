import SwiftUI

public struct DisclosureIndicator: View {
    public var body: some View {
        Image(systemName: "chevron.forward")
            .imageScale(.small)
            .foregroundStyle(Color.primary.tertiary)
    }
    
    public init() {}
}

#Preview {
    DisclosureIndicator()
}
