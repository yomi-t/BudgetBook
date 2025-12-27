import ComposableArchitecture
import SwiftUI

public struct BalanceView: View {
    
    public let store: StoreOf<BalanceReducer>
    public init (store: StoreOf<BalanceReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            BalanceGraphView(
                store: .init(
                    initialState: BalanceGraphReducer.State(balanceData: store.balances)
                ) {
                    BalanceGraphReducer()
                }
            )
            BalanceListView(
                store: .init(
                    initialState: BalanceListReducer.State(balances: store.balances)
                ) {
                    BalanceListReducer()
                }
            )
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}
