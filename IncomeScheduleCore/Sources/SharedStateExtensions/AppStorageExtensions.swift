import ComposableArchitecture
import Foundation

extension PersistenceReaderKey where Self == AppStorageKey<Bool> {
    public static var didAddInitialPaySource: Self {
        appStorage("didAddInitialPaySource")
    }
    
    public static var showCurrentMonthProminently: Self {
        appStorage("showCurrentMonthProminently")
    }
    
    public static var showMaxPayIndicators: Self {
        appStorage("showMaxPayIndicators")
    }
}

extension PersistenceReaderKey where Self == PersistenceKeyDefault<AppStorageKey<Bool>> {
    public static var didAddInitialPaySource: Self {
        PersistenceKeyDefault(.didAddInitialPaySource, false)
    }
    
    public static var showCurrentMonthProminently: Self {
        PersistenceKeyDefault(.showCurrentMonthProminently, true)
    }
    
    public static var showMaxPayIndicators: Self {
        PersistenceKeyDefault(.showMaxPayIndicators, true)
    }
}
