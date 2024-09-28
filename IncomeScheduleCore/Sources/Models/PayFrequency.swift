import Foundation

public enum PayFrequency {
    case weekly
    case biWeekly
    case monthly
}

extension PayFrequency: CaseIterable {}
extension PayFrequency: Codable {}
extension PayFrequency: Hashable {}

extension PayFrequency: Identifiable {
    public var id: String { name }
}

extension PayFrequency: Sendable {}

extension PayFrequency {
    public var name: String {
        switch self {
        case .weekly: "weekly"
        case .biWeekly: "bi-weekly"
        case .monthly: "monthly"
        }
    }
}
