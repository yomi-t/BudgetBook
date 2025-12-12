import Core
import SwiftData
import SwiftUI

@main
internal struct BudgetBookApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(SwiftDataModelConfigurationProvider.shared.container)
    }
}
