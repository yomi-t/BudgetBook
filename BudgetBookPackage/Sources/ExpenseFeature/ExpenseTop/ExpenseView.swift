import ComposableArchitecture
import Core
import SwiftUI

@ViewAction(for: ExpenseReducer.self)
public struct ExpenseView: View {
    public let store: StoreOf<ExpenseReducer>

    public init(store: StoreOf<ExpenseReducer>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()

                VStack {
                    ExpenseYearView(store: .init(
                        initialState: ExpenseYearReducer.State(
                            balances: store.balances,
                            incomes: store.incomes
                        )
                    ) {
                        ExpenseYearReducer()
                    })
                    ExpenseGraphView(store: .init(
                        initialState: ExpenseGraphReducer.State(
                            balances: store.balances,
                            incomes: store.incomes
                        )
                    ) {
                        ExpenseGraphReducer()
                    })
                    ExpenseListView(store: store.scope(
                        state: \.expenseListState,
                        action: \.expenseListAction
                    ))
                }
                .padding(.bottom, geometry.size.width / 5)
            }
            .onAppear {
                send(.onAppear)
            }
        }
    }
}
