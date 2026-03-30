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
                    ExpenseYearView(store: store.scope(
                        state: \.expenseYearState,
                        action: \.expenseYearAction
                    ))
                    ExpenseGraphView(store: store.scope(
                        state: \.expenseGraphState,
                        action: \.expenseGraphAction
                    ))
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
