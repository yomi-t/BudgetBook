import ComposableArchitecture
import SwiftUI

public struct BalanceView: View {
    
    public let store: StoreOf<BalanceReducer>
    public init (store: StoreOf<BalanceReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            LatestMoneyView(store: .init(
                initialState: LatestMoneyReducer.State(balanceData: store.balances),
            ) {
                LatestMoneyReducer()
            })
            BalanceGraphView(
                store: .init(
                    initialState: BalanceGraphReducer.State(balanceData: store.balances)
                ) {
                    BalanceGraphReducer()
                }
            )
            BalanceListView(store: store.scope(
                state: \.balanceListState,
                action: \.balanceListAction
            ))
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}
