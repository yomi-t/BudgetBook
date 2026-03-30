import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: BalanceReducer.self)
public struct BalanceView: View {

    public let store: StoreOf<BalanceReducer>
    public init (store: StoreOf<BalanceReducer>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { geometry in
            NavigationStackStore(
                store.scope(state: \.path, action: \.path)
            ) {
                ZStack {
                    BackgroundView()
                        .ignoresSafeArea()

                    VStack {
                        LatestMoneyView(store: store.scope(
                            state: \.latestMoneyState,
                            action: \.latestMoneyAction
                        ))
                        BalanceGraphView(store: store.scope(
                            state: \.balanceGraphState,
                            action: \.balanceGraphAction
                        ))
                        BalanceListView(store: store.scope(
                            state: \.balanceListState,
                            action: \.balanceListAction
                        ))
                    }
                    .padding(.bottom, geometry.size.width / 5)
                }
                .onAppear {
                    send(.onAppear)
                }
            } destination: { store in
                switch store.case {
                case let .balanceDetail(store):
                    GeometryReader { geometry in
                        ZStack {
                            BackgroundView()
                                .ignoresSafeArea()

                            BalanceDetailView(store: store)
                                .padding(.bottom, geometry.size.width / 5)
                        }
                    }
                }
            }
        }
    }
}
