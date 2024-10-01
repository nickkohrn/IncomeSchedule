import Foundation

public enum PayFrequency {
    case weekly
    case biWeekly
    
    public var name: String {
        switch self {
        case .weekly: "weekly"
        case .biWeekly: "bi-weekly"
        }
    }
}

extension PayFrequency: CaseIterable {}
extension PayFrequency: Codable {}
extension PayFrequency: Equatable {}
extension PayFrequency: Hashable {}

extension PayFrequency: Identifiable {
    public var id: String { name }
}

extension PayFrequency: Sendable {}
