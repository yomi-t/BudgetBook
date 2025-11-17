import ComposableArchitecture
import Core
import SwiftUI

public struct IncomeListView: View {
    public let store: StoreOf<IncomeListReducer>

    public init (store: StoreOf<IncomeListReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text("これまでの収入")
                .font(.title3)
                .padding(.bottom, 8)
                .padding(.top, 25)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(store.incomes, id: \.id) { item in
                        IncomeItemView(store: .init(
                            initialState: IncomeItemReducer.State(item: item)
                        ) {
                            IncomeItemReducer()
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
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

#Preview {
    IncomeListView(store: .init(
        initialState: IncomeListReducer.State(incomes: [])
    ) {
        IncomeListReducer()
    })
}
