import Foundation
import IdentifiedCollections
import Tagged

public struct Month {
    public typealias ID = Tagged<Self, Date>
    
    public let startDate: Date
    public var payDates: IdentifiedArrayOf<PayDate>
    
    public init(
        startDate: Date,
        payDates: IdentifiedArrayOf<PayDate>
    ) {
        self.startDate = startDate
        self.payDates = payDates
    }
}

extension Month: Codable {}
extension Month: Equatable {}
extension Month: Hashable {}

extension Month: Identifiable {
    public var id: ID { Tagged(startDate) }
}

extension Month: Sendable {}
