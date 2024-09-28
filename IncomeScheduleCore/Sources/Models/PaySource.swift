import Foundation
import Tagged

public struct PaySource {
    public typealias ID = Tagged<Self, UUID>
    
    public let name: String
    public let schedule: PaySchedule
    public let uuid: UUID
    
    public init(name: String, schedule: PaySchedule, uuid: UUID) {
        self.name = name
        self.schedule = schedule
        self.uuid = uuid
    }
}

extension PaySource: Codable {}
extension PaySource: Equatable {}
extension PaySource: Hashable {}

extension PaySource: Identifiable {
    public var id: ID { Tagged(uuid) }
}

extension PaySource: Sendable {}
