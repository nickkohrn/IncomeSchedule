import Foundation
import Tagged

public struct Month {
    public typealias ID = Tagged<Self, Date>
    
    public let startDate: Date
    
    public init(startDate: Date) {
        self.startDate = startDate
    }
}

extension Month: Codable {}
extension Month: Equatable {}
extension Month: Hashable {}

extension Month: Identifiable {
    public var id: ID { Tagged(startDate) }
}

extension Month: Sendable {}
