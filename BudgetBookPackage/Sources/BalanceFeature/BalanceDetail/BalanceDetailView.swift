import ComposableArchitecture
import SwiftUI

public struct BalanceDetailView: View {
    public let store: StoreOf<BalanceDetailReducer>
    public init(store: StoreOf<BalanceDetailReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            AccountRateGraphView(data: store.balances)
            BalanceAccountListView(store: store.scope(
                state: \.balanceAccountListState,
                action: \.balanceAccountListAction
            ))
        }
    }
}
