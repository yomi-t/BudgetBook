import ComposableArchitecture
import Core
import Foundation

@Reducer
public struct ExpenseYearReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var expenseYearTotal: Int = 0

        public init(balances: [Balance] = [], incomes: [Income] = []) {
            self.expenseYearTotal = calculateYearlyExpenseTotal(balances: balances, incomes: incomes)
        }
    }

    public enum Action: ViewAction, Sendable {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none
            }
        }
    }
}

extension ExpenseYearReducer.State {
    private func calculateYearlyExpenseTotal(balances: [Balance], incomes: [Income]) -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return ExpenseManager().computeMonthlyExpenses(balances: balances, incomes: incomes)
            .filter { $0.year == currentYear }
            .reduce(0) { $0 + $1.amount }
    }
}
