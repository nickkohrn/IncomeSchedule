import Foundation
import IdentifiedCollections
import Tagged

public struct YearSchedule {
    public typealias ID = Tagged<Self, UUID>
    
    public let monthSchedules: IdentifiedArrayOf<MonthSchedule>
    public let uuid: UUID
    
    public init(
        monthSchedules: IdentifiedArrayOf<MonthSchedule>,
        uuid: UUID
    ) {
        self.monthSchedules = monthSchedules
        self.uuid = uuid
    }
}

extension YearSchedule: Equatable {}
extension YearSchedule: Hashable {}

extension YearSchedule: Identifiable {
    public var id: ID { Tagged(uuid) }
}
