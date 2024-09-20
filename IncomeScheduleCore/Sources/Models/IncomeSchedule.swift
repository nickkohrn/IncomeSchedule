import Foundation

public struct IncomeSchedule {
    public var date: Date
    public var frequency: IncomeFrequency
    
    public init(
        date: Date,
        frequency: IncomeFrequency
    ) {
        self.date = date
        self.frequency = frequency
    }
}

extension IncomeSchedule: Codable {}
extension IncomeSchedule: Equatable {}
extension IncomeSchedule: Sendable {}
