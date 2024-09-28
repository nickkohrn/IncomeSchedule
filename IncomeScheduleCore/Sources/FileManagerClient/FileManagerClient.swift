import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct FileManagerClient: Sendable {
    public enum Error: Swift.Error {
        case missingURL
    }
    
    public var paySourcesFileURL: @Sendable () throws -> URL = { .temporaryDirectory }
}

extension FileManagerClient: DependencyKey {
    public static let liveValue: FileManagerClient = {
        FileManagerClient(
            paySourcesFileURL: {
                guard let containerURL = FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier: "group.com.bryankohrn.IncomeSchedule"
                ) else {
                    throw Error.missingURL
                }
                return containerURL.appending(path: "PaySources")
            }
        )
    }()
    
    public static let previewValue: FileManagerClient = {
        FileManagerClient(
            paySourcesFileURL: {
                .temporaryDirectory
            }
        )
    }()
}

extension DependencyValues {
    public var fileManagerClient: FileManagerClient {
        get { self[FileManagerClient.self] }
        set { self[FileManagerClient.self] = newValue }
    }
}
