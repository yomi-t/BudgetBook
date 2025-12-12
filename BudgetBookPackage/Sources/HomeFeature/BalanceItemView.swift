import ComposableArchitecture
import SwiftUI

public struct BalanceItemView: View {
    public let store: StoreOf<BalanceItemReducer>
    public init (store: StoreOf<BalanceItemReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(store.item.account)
                    .font(.title3)
                Spacer()
                    .frame(minWidth: 0)
                Text("\(store.item.amount)")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 20)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 8)
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    BalanceItemView(store: .init(
        initialState: BalanceItemReducer.State(item: .init(account: "三井住友", year: 2025, month: 4, amount: 100_000))
    ) {
        BalanceItemReducer()
    })
}
