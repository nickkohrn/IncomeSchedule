import Foundation

public struct PaySchedule {
    public var date: Date
    public var frequency: PayFrequency
    
    public init(
        date: Date,
        frequency: PayFrequency
    ) {
        self.date = date
        self.frequency = frequency
    }
}

extension PaySchedule: Codable {}
extension PaySchedule: Equatable {}
extension PaySchedule: Hashable {}
extension PaySchedule: Sendable {}
