import ComposableArchitecture
import FileManagerClient
import Foundation
import Models

extension PersistenceReaderKey where Self == FileStorageKey<PaySources> {
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


extension PersistenceReaderKey where Self == PersistenceKeyDefault<FileStorageKey<PaySources>> {
    public static var paySources: Self {
        PersistenceKeyDefault(
            .paySources,
            PaySources(sources: [])
        )
    }
}
