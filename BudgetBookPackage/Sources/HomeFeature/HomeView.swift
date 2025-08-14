import ComposableArchitecture
import SwiftUI

@ViewAction(for: HomeReducer.self)
public struct HomeView: View {
    public let store: StoreOf<HomeReducer>
    public init (store: StoreOf<HomeReducer>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                LastMoneyView(store: .init(
                    initialState: LatestMoneyReducer.State(latestMoney: store.latestMoney)
                ) {
                    LatestMoneyReducer()
                })
                
                BalanceListView(store: .init(
                    initialState: BalanceListReducer.State(store.latestBalances)
                ) {
                    BalanceListReducer()
                })
                .frame(height: geometry.size.height - 130)
            }
        }
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview {
    HomeView(store: .init(
        initialState: HomeReducer.State()
    ) {
        HomeReducer()
    })
}
