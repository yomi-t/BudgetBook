import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: IncomeListReducer.self)
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
            
            List {
                ForEach(store.monthlyIncomes, id: \.self) { item in
                    Button(
                        action: {
                            send(.onTapCell(item))
                        }, label: {
                            IncomeItemView(monthlyIncome: item)
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
    IncomeListView(store: .init(
        initialState: IncomeListReducer.State(incomes: [])
    ) {
        IncomeListReducer()
    })
}
