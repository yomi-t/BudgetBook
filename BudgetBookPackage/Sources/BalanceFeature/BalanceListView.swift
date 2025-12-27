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
            Text("これまでの残高記録")
                .font(.title3)
                .padding(.bottom, 8)
                .padding(.top, 25)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)
            
            List {
                ForEach(store.balances, id: \.id) { item in
                    BalanceListItemView(balance: item)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            store.send(.onTapDelete(item))
                        } label: {
                            Label("", systemImage: "trash")
                        }
                    }
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
            }
            .frame(maxHeight: .infinity)
            .listStyle(.plain)
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
