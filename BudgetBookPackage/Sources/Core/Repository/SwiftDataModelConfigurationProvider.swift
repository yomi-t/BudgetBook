import SwiftData

public class SwiftDataModelConfigurationProvider {
    // Singleton instance for configuration
    nonisolated(unsafe) public static let shared = SwiftDataModelConfigurationProvider()

    private let _container: ModelContainer

    // Private initializer to enforce singleton pattern
    private init() {
        // Define schema and configuration
        let schema = Schema(
            [
                BalanceDTO.self,
                IncomeDTO.self
            ]
        )
        let configuration = ModelConfiguration(isStoredInMemoryOnly: false)

        // Create ModelContainer with schema and configuration
        // swiftlint:disable:next force_try
        self._container = try! ModelContainer(for: schema, configurations: [configuration])
    }

    public var container: ModelContainer {
        _container
    }
}
