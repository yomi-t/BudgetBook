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

    public enum Action: ViewAction {
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
        let months = Set(incomes.filter { $0.year == currentYear }.map { $0.month })
        return months.reduce(0) { sum, month in
            sum + ExpenseManager.calculateExpense(balances: balances, incomes: incomes, year: currentYear, month: month)
        }
    }
}
