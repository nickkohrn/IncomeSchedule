import Foundation
import Tagged

public struct PayDate {
    public typealias ID = Tagged<Self, Date>
    
    public let date: Date
    public let source: PaySource
}

extension PayDate: Codable {}
extension PayDate: Equatable {}
extension PayDate: Hashable {}

extension PayDate: Identifiable {
    public var id: ID { Tagged(date) }
}

extension PayDate: Sendable {}
