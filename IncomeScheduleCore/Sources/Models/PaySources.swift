import Foundation
import IdentifiedCollections

public struct PaySources {
    public var sources: IdentifiedArrayOf<PaySource>
    
    public var sortedAlphabetically: IdentifiedArrayOf<PaySource> {
        let sorted = sources.sorted { lhs, rhs in
            lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
        }
        return IdentifiedArray(uniqueElements: sorted)
    }
    
    public init(sources: IdentifiedArrayOf<PaySource>) {
        self.sources = sources
    }
}

extension PaySources: Codable {}
extension PaySources: Equatable {}
extension PaySources: Hashable {}
extension PaySources: Sendable {}
