import AppFeature
import Core
// import IncomeFeature
import SwiftData
import SwiftUI

public struct ContentView: View {
    @Environment(\.modelContext)
    private var modelContext

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
//        IncomeView(
//            store: .init(
//                initialState: IncomeReducer.State()
//            ) {
//                IncomeReducer(incomeRepository: incomeRepository)
//            }
//        )
    }
}

#Preview {
    ContentView()
}
