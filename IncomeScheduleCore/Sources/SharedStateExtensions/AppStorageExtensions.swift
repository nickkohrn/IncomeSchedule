import ComposableArchitecture
import Foundation

extension PersistenceReaderKey where Self == AppStorageKey<Bool> {
    public static var didAddInitialPaySource: Self {
        appStorage("didAddInitialPaySource")
    }
}

extension PersistenceReaderKey where Self == PersistenceKeyDefault<AppStorageKey<Bool>> {
    public static var didAddInitialPaySource: Self {
        PersistenceKeyDefault(.didAddInitialPaySource, false)
    }
}
