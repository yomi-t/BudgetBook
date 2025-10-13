import ComposableArchitecture
import SwiftUI

public struct IncomeItemView: View {
    public let store: StoreOf<IncomeItemReducer>
    public init (store: StoreOf<IncomeItemReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("\(store.item.year - 2000)年\(store.item.month)月")
                Text(store.item.source)
                    .font(.title3)
                Spacer()
                    .layoutPriority(-.infinity)
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
    IncomeItemView(store: .init(
        initialState: IncomeItemReducer.State(item: .init(source: "リクルート", year: 2024, month: 6, amount: 300_000))
    ) {
        IncomeItemReducer()
    })
}
