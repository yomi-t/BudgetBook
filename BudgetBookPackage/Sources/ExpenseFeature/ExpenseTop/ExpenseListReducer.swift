import ComposableArchitecture
import Core

public struct MonthlyExpense: Equatable, Sendable, Hashable {
    public var year: Int
    public var month: Int
    public var amount: Int
}

@Reducer
public struct ExpenseListReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var monthlyExpenses: [MonthlyExpense] = []

        public init(balances: [Balance] = [], incomes: [Income] = []) {
            self.monthlyExpenses = computeMonthlyExpenses(balances: balances, incomes: incomes)
        }
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none
            }
        }
    }
}

extension ExpenseListReducer.State {
    private func computeMonthlyExpenses(balances: [Balance], incomes: [Income]) -> [MonthlyExpense] {
        ExpenseManager().computeMonthlyExpenses(balances: balances, incomes: incomes)
            .map { MonthlyExpense(year: $0.year, month: $0.month, amount: $0.amount) }
            .sorted { lhs, rhs in
                if lhs.year == rhs.year { return lhs.month > rhs.month }
                return lhs.year > rhs.year
            }
    }
}
