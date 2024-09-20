import Foundation

public enum IncomeFrequency {
    case weekly
    case biWeekly
}

extension IncomeFrequency: CaseIterable {}
extension IncomeFrequency: Codable {}
extension IncomeFrequency: Hashable {}

extension IncomeFrequency: Identifiable {
    public var id: String { name }
}

extension IncomeFrequency: Sendable {}

extension IncomeFrequency {
    public var name: String {
        switch self {
        case .weekly: "weekly"
        case .biWeekly: "bi-weekly"
        }
    }
}
