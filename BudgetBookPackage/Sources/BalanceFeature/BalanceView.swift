import ComposableArchitecture
import Core
import SwiftUI

public struct BalanceView: View {

    public let store: StoreOf<BalanceReducer>
    public init (store: StoreOf<BalanceReducer>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()

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
                .padding(.bottom, geometry.size.width / 5)
            }
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}
