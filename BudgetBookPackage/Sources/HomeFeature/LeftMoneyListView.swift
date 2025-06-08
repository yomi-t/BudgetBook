import ComposableArchitecture
import SharedModel
import SwiftUI

public struct LeftMoneyListView: View {
    public let store: StoreOf<LeftMoneyListReducer>

    public init (store: StoreOf<LeftMoneyListReducer>) {
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
            ForEach(store.testData, id: \.id) { item in
                LeftMoneyItemView(store: .init(
                    initialState: LeftMoneyItemReducer.State(item: item)
                ) {
                    LeftMoneyItemReducer()
                })
            }
            Spacer()
                .frame(minHeight: 0)
        }
        .background(.ultraThickMaterial)
        .cornerRadius(20)
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .shadow(radius: 10)
    }
}

#Preview {
    LeftMoneyListView(store: .init(
        initialState: LeftMoneyListReducer.State()
    ) {
        LeftMoneyListReducer()
    })
}
