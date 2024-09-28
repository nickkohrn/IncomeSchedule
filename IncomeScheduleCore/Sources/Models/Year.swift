import Foundation
import IdentifiedCollections
import Tagged

public struct Year {
    public typealias ID = Tagged<Self, Date>
    
    public let startDate: Date
    public let months: IdentifiedArrayOf<Month>
    
    public init(startDate: Date, months: IdentifiedArrayOf<Month>) {
        self.startDate = startDate
        self.months = months
    }
}

extension Year: Codable {}
extension Year: Equatable {}
extension Year: Hashable {}

extension Year: Identifiable {
    public var id: ID { Tagged(startDate) }
}

extension Year: Sendable {}
