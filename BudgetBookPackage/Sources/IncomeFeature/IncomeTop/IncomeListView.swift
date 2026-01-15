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
            
            List {
                ForEach(store.monthlyIncomes, id: \.self) { item in
                    Button(
                        action: {
                            store.send(.onTapCell(item))
                        }, label: {
                            IncomeItemView(monthlyIncome: item)
                        }
                    )
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

#Preview {
    IncomeListView(store: .init(
        initialState: IncomeListReducer.State(incomes: [])
    ) {
        IncomeListReducer()
    })
}
