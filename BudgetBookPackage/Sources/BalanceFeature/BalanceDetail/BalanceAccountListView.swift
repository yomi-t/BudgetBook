import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: BalanceAccountListReducer.self)
public struct BalanceAccountListView: View {
    public let store: StoreOf<BalanceAccountListReducer>
    public init (store: StoreOf<BalanceAccountListReducer>) {
        self.store = store
    }
    public var body: some View {
        VStack(spacing: 0) {
            Text("\(String(store.year))年\(String(store.month))月の残高")
                .font(.title3)
                .padding(.bottom, 8)
                .padding(.top, 25)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)

            List {
                ForEach(store.balances, id: \.self) { data in
                    BalanceAccountItemView(balance: data)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                send(.onTapDelete(data))
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
        .padding(.top, 10)
        .padding(.bottom, 20)
        .shadow(radius: 10)
    }
}
