import Foundation

public struct Year {
    public let yearStartDate: Date
    public let months: [Month]
    public let uuid: UUID
    
    public var maximumPays: Int {
        months.map(\.coalescedPayDates.count).max() ?? 0
    }
    
    public init(yearStartDate: Date, months: [Month], uuid: UUID) {
        self.yearStartDate = yearStartDate
        self.months = months
        self.uuid = uuid
    }
}

extension Year: Codable {}
extension Year: Equatable {}
extension Year: Hashable {}

extension Year: Identifiable {
    public var id: UUID { uuid }
}

extension Year: Sendable {}
