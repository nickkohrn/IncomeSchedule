import Foundation
import Tagged

public struct MonthSchedule {
    public typealias ID = Tagged<Self, UUID>
    
    public let incomeDates: [Date]
    public let uuid: UUID
    
    public init(
        incomeDates: [Date],
        uuid: UUID
    ) {
        self.incomeDates = incomeDates
        self.uuid = uuid
    }
}

extension MonthSchedule: Equatable {}
extension MonthSchedule: Hashable {}

extension MonthSchedule: Identifiable {
    public var id: ID { Tagged(uuid) }
}
