import AppFeature
import Core
// import IncomeFeature
import SwiftData
import SwiftUI

public struct ContentView: View {

    public var body: some View {

        AppView(
            store: .init(
                initialState: AppReducer.State()
            ) {
                AppReducer()
            }
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
