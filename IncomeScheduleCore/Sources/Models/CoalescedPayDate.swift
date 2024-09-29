import Foundation

public struct CoalescedPayDate {
    public let date: Date
    public let sources: [PaySource]
    public let uuid: UUID
    
    public init(date: Date, sources: [PaySource], uuid: UUID) {
        self.date = date
        self.sources = sources
        self.uuid = uuid
    }
}

extension CoalescedPayDate: Codable {}
extension CoalescedPayDate: Equatable {}
extension CoalescedPayDate: Hashable {}

extension CoalescedPayDate: Identifiable {
    public var id: UUID { uuid }
}

extension CoalescedPayDate: Sendable {}
