import ComposableArchitecture
import FileManagerClient
import Foundation
import Models
import Tagged

extension PersistenceReaderKey where Self == FileStorageKey<IdentifiedArrayOf<PaySource>> {
    public static var paySources: Self {
        @Dependency(\.fileManagerClient) var fileManagerClient
        do {
            let fileURL = try fileManagerClient.paySourcesFileURL()
            return fileStorage(fileURL)
        } catch {
            fatalError("Missing URL for pay sources")
        }
    }
}


extension PersistenceReaderKey where Self == PersistenceKeyDefault<FileStorageKey<IdentifiedArrayOf<PaySource>>> {
    public static var paySources: Self {
        PersistenceKeyDefault(.paySources, [])
    }
}
