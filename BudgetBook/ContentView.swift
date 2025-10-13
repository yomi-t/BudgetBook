import AppFeature
import Repository
import SharedModel
import SwiftData
import SwiftUI

public struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    public var body: some View {
        let balanceRepository = BalanceRepository(modelContext: modelContext)
        let incomeRepository = IncomeRepository(modelContext: modelContext)

        AppView(
            store: .init(
                initialState: AppReducer.State()
            ) {
                AppReducer(balanceRepository: balanceRepository, incomeRepository: incomeRepository)
            },
            balanceRepository: balanceRepository,
            incomeRepository: incomeRepository
        )
    }
}

#Preview {
    ContentView()
}
