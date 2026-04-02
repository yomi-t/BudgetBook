import ComposableArchitecture
import Core

@Reducer
public struct ExpenseGraphReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var graphData: [ExpenseGraphModel]
        public var range: ClosedRange<Int>

        public init(balances: [Balance] = [], incomes: [Income] = []) {
            let gData = Self.computeGraphData(balances: balances, incomes: incomes)
            self.graphData = gData
            self.range = gData.rangeAmount()
        }
    }

    public enum Action: Sendable, ViewAction {
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

extension ExpenseGraphReducer.State {
    private static func computeGraphData(balances: [Balance], incomes: [Income]) -> [ExpenseGraphModel] {
        var seen: Set<String> = []
        var data: [ExpenseGraphModel] = []

        for income in incomes {
            let key = "\(income.year)-\(income.month)"
            if !seen.contains(key) {
                seen.insert(key)
                let amount = ExpenseManager.calculateExpense(
                    balances: balances,
                    incomes: incomes,
                    year: income.year,
                    month: income.month
                )
                let monthStr = String(format: "%02d", income.month)
                let yearStr = String(format: "%02d", income.year % 100)
                data.append(ExpenseGraphModel(yearMonth: "\(yearStr)/\(monthStr)", amount: amount))
            }
        }

        return data.sortByMonth()
    }
}
