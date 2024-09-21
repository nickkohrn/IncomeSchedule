import ComposableArchitecture
import Foundation
import Models

extension PersistenceReaderKey where Self == FileStorageKey<IncomeSchedule> {
    public static var incomeSchedule: Self {
        do {
            let fileURL = try FileManager.default
                .url(
                    for: .applicationSupportDirectory,
                    in: .userDomainMask,
                    appropriateFor: nil,
                    create: true
                )
                .appendingPathComponent("incomeSchedule")
            return fileStorage(fileURL)
        } catch {
            fatalError("Missing file URL for income schedule: \(error)")
        }
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
