import Foundation
import IdentifiedCollections
import Tagged

public struct PayYearSchedule {
    public typealias ID = Tagged<Self, UUID>
    
    public let monthSchedules: IdentifiedArrayOf<PayMonthSchedule>
    public let uuid: UUID
    
    public init(
        monthSchedules: IdentifiedArrayOf<PayMonthSchedule>,
        uuid: UUID
    ) {
        self.monthSchedules = monthSchedules
        self.uuid = uuid
    }
}

extension PayYearSchedule: Codable {}
extension PayYearSchedule: Equatable {}
extension PayYearSchedule: Hashable {}

extension PayYearSchedule: Identifiable {
    public var id: ID { Tagged(uuid) }
}

extension PayYearSchedule: Sendable {}
