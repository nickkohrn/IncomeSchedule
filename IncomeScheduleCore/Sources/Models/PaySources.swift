import Foundation
import IdentifiedCollections

public struct PaySources {
    public var sources: IdentifiedArrayOf<PaySource>
    
    public init(sources: IdentifiedArrayOf<PaySource>) {
        self.sources = sources
    }
}

extension PaySources: Codable {}
extension PaySources: Equatable {}
extension PaySources: Hashable {}
extension PaySources: Sendable {}
