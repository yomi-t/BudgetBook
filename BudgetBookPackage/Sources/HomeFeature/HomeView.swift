import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: HomeReducer.self)
public struct HomeView: View {
    public let store: StoreOf<HomeReducer>
    public init (store: StoreOf<HomeReducer>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    LatestMoneyView(store: .init(
                        initialState: LatestMoneyReducer.State(latestMoney: store.latestMoney)
                    ) {
                        LatestMoneyReducer()
                    })

                    BalanceListView(store: .init(
                        initialState: BalanceListReducer.State(store.latestBalances)
                    ) {
                        BalanceListReducer()
                    })
                    .frame(height: max(0, geometry.size.height - 130 - geometry.size.width / 5))
                }
                .padding(.bottom, geometry.size.width / 5)
            }
        }
        .onAppear {
            send(.onAppear)
        }
    }
}
