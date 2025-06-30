import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    public let store: StoreOf<HomeReducer>
    public init (store: StoreOf<HomeReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            LastMoneyView(store: .init(
                initialState: LastMoneyReducer.State()
            ) {
                LastMoneyReducer()
            })
            LeftMoneyListView(store: .init(
                initialState: LeftMoneyListReducer.State()
            ) {
                LeftMoneyListReducer()
            })
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
