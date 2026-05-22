import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: BalanceListReducer.self)
public struct BalanceListView: View {
    public let store: StoreOf<BalanceListReducer>

    public init (store: StoreOf<BalanceListReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            Text(L10n.Balance.List.title)
                .font(.title3)
                .padding(.bottom, 8)
                .padding(.top, 25)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray)
                .padding(.horizontal, 20)

            List {
                ForEach(store.monthlyBalances, id: \.self) { item in
                    Button(
                        action: {
                            send(.onTapCell(item))
                        }, label: {
                            BalanceListItemView(monthlyBalance: item)
                                .contentShape(Rectangle())
                        }
                    )
                    .buttonStyle(ListItemButtonStyle())
                }
                .listRowSeparator(.hidden, edges: .all)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.clear)
                .padding(.horizontal, 16)
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
        .onAppear {
            send(.onAppear)
        }
    }
}

#Preview {
    BalanceListView(store: .init(
        initialState: BalanceListReducer.State(),
    ) {
        BalanceListReducer()
    })
}
