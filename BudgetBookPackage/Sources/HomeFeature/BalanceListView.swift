import ComposableArchitecture
import Core
import SwiftUI

public struct BalanceListView: View {
    public let store: StoreOf<BalanceListReducer>

    public init (store: StoreOf<BalanceListReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text("項目ごとの残金")
                .font(.title3)
                .padding(.bottom, 8)
                .padding(.top, 25)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.balances, id: \.id) { item in
                        BalanceItemView(store: .init(
                            initialState: BalanceItemReducer.State(item: item)
                        ) {
                            BalanceItemReducer()
                        })
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .shadow(radius: 10)
    }
}

#Preview {
    BalanceListView(store: .init(
        initialState: BalanceListReducer.State([])
    ) {
        BalanceListReducer()
    })
}
