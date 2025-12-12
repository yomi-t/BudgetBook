import ComposableArchitecture
import SwiftUI

public struct IncomeView: View {
    public let store: StoreOf<IncomeReducer>
    public init (store: StoreOf<IncomeReducer>) {
        self.store = store
    }
    public var body: some View {
        VStack {
            IncomeGraphView(store: .init(
                initialState:
                    IncomeGraphReducer.State(incomeData: store.incomes)
            ) {
                IncomeGraphReducer()
            })
            IncomeListView(store: store.scope(
                state: \.incomeListState,
                action: \.incomeListAction
            ))
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

#Preview {
    
}
