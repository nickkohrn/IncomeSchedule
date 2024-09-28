import Foundation

public struct PaySource {
    public let name: String
    public let schedule: PaySchedule
    
    public init(name: String, schedule: PaySchedule) {
        self.name = name
        self.schedule = schedule
    }
}

extension PaySource: Codable {}
extension PaySource: Equatable {}
extension PaySource: Hashable {}
extension PaySource: Sendable {}
