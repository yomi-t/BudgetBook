import ComposableArchitecture
import SwiftData

extension DependencyValues {
    var databaseService: Database {
        get { self[Database.self] }
        set { self[Database.self] = newValue }
    }
}

public struct Database: Sendable {
    public var context: @Sendable @DataActor () throws -> ModelContext
}

extension Database: DependencyKey {
    public static let liveValue = Self {
        ModelContext(SwiftDataModelConfigurationProvider.shared.container)
    }
}
