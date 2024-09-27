import ComposableArchitecture
import Foundation
import Models

extension PersistenceReaderKey where Self == FileStorageKey<IncomeSchedule> {
    public static var incomeSchedule: Self {
        let fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.bryankohrn.IncomeSchedule")?
            .appendingPathComponent("incomeSchedule")
        guard let fileURL else {
            fatalError("Missing file URL for income schedule")
        }
        return fileStorage(fileURL)
    }
}


extension PersistenceReaderKey where Self == PersistenceKeyDefault<FileStorageKey<IncomeSchedule>> {
    public static var incomeSchedule: Self {
        PersistenceKeyDefault(.incomeSchedule, IncomeSchedule(date: .now, frequency: .biWeekly))
    }
}

extension PersistenceReaderKey where Self == AppStorageKey<Bool> {
    public static var didSetInitialIncomeSchedule: Self {
        appStorage("didSetInitialIncomeScheduleKey")
    }
}


extension PersistenceReaderKey where Self == PersistenceKeyDefault<AppStorageKey<Bool>> {
    public static var didSetInitialIncomeSchedule: Self {
        PersistenceKeyDefault(.didSetInitialIncomeSchedule, false)
    }
}
