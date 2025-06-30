import ComposableArchitecture
import SwiftUI

public struct LeftMoneyItemView: View {
    public let store: StoreOf<LeftMoneyItemReducer>
    public init (store: StoreOf<LeftMoneyItemReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(store.item.title)
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
    LeftMoneyItemView(store: .init(
        initialState: LeftMoneyItemReducer.State(item: .init(id: "a", title: "三井住友", amount: 100_000))
    ) {
        LeftMoneyItemReducer()
    })
}
