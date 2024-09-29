import Foundation

public struct PaySource {
    public let name: String
    public let frequency: PayFrequency
    public let referencePayDate: Date
    public let uuid: UUID
    
    public init(name: String, frequency: PayFrequency, referencePayDate: Date, uuid: UUID) {
        self.name = name
        self.frequency = frequency
        self.referencePayDate = referencePayDate
        self.uuid = uuid
    }
}

extension PaySource: Codable {}
extension PaySource: Equatable {}
extension PaySource: Hashable {}

extension PaySource: Identifiable {
    public var id: UUID { uuid }
}

extension PaySource: Sendable {}
