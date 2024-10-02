import Foundation
import IdentifiedCollections

public struct Year {
    public let yearStartDate: Date
    public let months: IdentifiedArrayOf<Month>
    public let uuid: UUID
    
    public var maximumPayCount: Int {
        months.map(\.coalescedPayDates.count).max() ?? 0
    }
    
    public var maximumPayMonths: IdentifiedArrayOf<Month> {
        months.filter { month in
            month.coalescedPayDates.count == maximumPayCount
        }
    }
    
    public init(yearStartDate: Date, months: IdentifiedArrayOf<Month>, uuid: UUID) {
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
