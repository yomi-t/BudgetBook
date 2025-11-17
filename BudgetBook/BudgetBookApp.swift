import Core
import SwiftData
import SwiftUI

@main
internal struct BudgetBookApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Balance.self, Income.self])
    }
}
