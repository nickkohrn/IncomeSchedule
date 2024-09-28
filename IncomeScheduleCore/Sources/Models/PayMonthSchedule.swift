import Foundation
import Tagged

public struct PayMonthSchedule {
    public typealias ID = Tagged<Self, UUID>
    
    public let payDates: [Date]
    public let uuid: UUID
    
    public var firstDate: Date? {
        payDates.first
    }
    
    public init(
        payDates: [Date],
        uuid: UUID
    ) {
        self.payDates = payDates
        self.uuid = uuid
    }
}

extension PayMonthSchedule: Codable {}
extension PayMonthSchedule: Equatable {}
extension PayMonthSchedule: Hashable {}

extension PayMonthSchedule: Identifiable {
    public var id: ID { Tagged(uuid) }
}

extension PayMonthSchedule: Sendable {}
