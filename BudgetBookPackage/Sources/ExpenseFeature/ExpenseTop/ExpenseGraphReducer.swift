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
        ExpenseManager().computeMonthlyExpenses(balances: balances, incomes: incomes)
            .map { ExpenseGraphModel(yearMonth: $0.displayMonth, amount: $0.amount) }
            .sortByMonth()
    }
}
