import Dependencies
import Foundation

public struct CoalescedPayDate {
    public let date: Date
    public let sources: [PaySource]
    public let uuid: UUID
    
    public var sortedSourceNames: [String] {
        sources.map(\.name).sorted { lhs, rhs in
            lhs.localizedStandardCompare(rhs) == .orderedAscending
        }
    }
    
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

extension CoalescedPayDate {
    public struct Formatter<Output> {
        public let format: (CoalescedPayDate) -> Output
        
        public init(format: @escaping (CoalescedPayDate) -> Output) {
            self.format = format
        }
    }
    
    public func formatted<Output>(_ formatter: Formatter<Output>) -> Output {
        formatter.format(self)
    }
}

extension CoalescedPayDate.Formatter where Output == String {
    public static var daysUntil: Self {
        Self { value in
            @Dependency(\.calendar) var calendar
            @Dependency(\.date.now) var now
            let startOfToday = calendar.startOfDay(for: now)
            //        let startOfPayDate = calendar.startOfDay(for: payDate)
            //        if calendar.isDateInToday(startOfPayDate)
            //            || calendar.isDateInTomorrow(payDate) {
            //            let formatter = DateFormatter()
            //            formatter.dateStyle = .full
            //            formatter.doesRelativeDateFormatting = true
            //            formatter.formattingContext = .standalone
            //            return formatter.string(from: startOfPayDate).localizedLowercase
            //        } else {
            //            let dateComponents = calendar.dateComponents(
            //                [.day],
            //                from: startOfToday,
            //                to: startOfPayDate
            //            )
            //            let formatter = DateComponentsFormatter()
            //            formatter.calendar = calendar
            //            formatter.formattingContext = .standalone
            //            formatter.unitsStyle = spellNumbers ? .spellOut : .full
            //            return formatter.string(from: dateComponents)?.localizedLowercase ?? ""
            //        }
            return ""
        }
    }
}









//extension CoalescedPayDate {
//    public struct Formatter<Output> {
//        public struct Input {
//            public let coalescedPayDate: CoalescedPayDate
//            public let calendar: Calendar
//            public let now: Date
//            
//            public init(coalescedPayDate: CoalescedPayDate, calendar: Calendar, now: Date) {
//                self.coalescedPayDate = coalescedPayDate
//                self.calendar = calendar
//                self.now = now
//            }
//        }
//        
//        public let format: (Input) -> Output
//    }
//    
//    public func formatted<Output>(input: CoalescedPayDate.Formatter<String>.Input, formatter: Formatter<Output>) -> Output {
//        formatter.format(input)
//    }
//}
//
//extension CoalescedPayDate.Formatter where Output == String {
//    public static var daysUntil: CoalescedPayDate.Formatter<String> {
//        CoalescedPayDate.Formatter { payDate, calendar in
////            let startOfToday = calendar.startOfDay(for: now)
////            let startOfPayDate = calendar.startOfDay(for: date)
////            if calendar.isDateInToday(startOfPayDate)
////                || calendar.isDateInTomorrow(date) {
////                let formatter = DateFormatter()
////                formatter.dateStyle = .full
////                formatter.doesRelativeDateFormatting = true
////                formatter.formattingContext = .standalone
////                return formatter.string(from: startOfPayDate).localizedLowercase
////            } else {
////                let dateComponents = calendar.dateComponents(
////                    [.day],
////                    from: startOfToday,
////                    to: startOfPayDate
////                )
////                let formatter = DateComponentsFormatter()
////                formatter.calendar = calendar
////                formatter.formattingContext = .standalone
////                formatter.unitsStyle = .full
////                return formatter.string(from: dateComponents)?.localizedLowercase ?? ""
////            }
//            return ""
//        }
//    }
//}
