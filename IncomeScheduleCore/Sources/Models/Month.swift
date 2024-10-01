import Foundation

public struct Month {
    public let isCurrentMonth: Bool
    public let monthStartDate: Date
    public let payDates: [PayDate]
    public let uuid: UUID
    
    public var coalescedPayDates: [CoalescedPayDate] {
        var result: [Date: [PaySource]] = [:]
        for payDate in payDates {
            result[payDate.date, default: []].append(payDate.source)
        }
        let sortedByDate = result.sorted { $0.key < $1.key }
        return sortedByDate.map { date, sources in
            CoalescedPayDate(date: date, sources: sources, uuid: UUID())
        }
    }
    
    public init(isCurrentMonth: Bool, monthStartDate: Date, payDates: [PayDate], uuid: UUID) {
        self.isCurrentMonth = isCurrentMonth
        self.monthStartDate = monthStartDate
        self.payDates = payDates
        self.uuid = uuid
    }
}

extension Month: Codable {}
extension Month: Equatable {}
extension Month: Hashable {}

extension Month: Identifiable {
    public var id: UUID { uuid }
}

extension Month: Sendable {}
