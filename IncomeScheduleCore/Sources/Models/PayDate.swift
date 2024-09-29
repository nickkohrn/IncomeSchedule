import Foundation

public struct PayDate {
    public let date: Date
    public let source: PaySource
    public let uuid: UUID
    
    public init(date: Date, source: PaySource, uuid: UUID) {
        self.date = date
        self.source = source
        self.uuid = uuid
    }
}

extension PayDate: Codable {}
extension PayDate: Equatable {}
extension PayDate: Hashable {}

extension PayDate: Identifiable {
    public var id: UUID { uuid }
}

extension PayDate: Sendable {}
