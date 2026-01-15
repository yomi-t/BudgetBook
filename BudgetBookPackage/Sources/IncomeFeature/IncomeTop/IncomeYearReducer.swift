import ComposableArchitecture
import Core
import Foundation

@Reducer
public struct IncomeYearReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var incomeYearTotal: Int = 0
        public init(incomeData: [Income]) {
            self.incomeYearTotal = calculateYearlyIncomeTotal(from: incomeData)
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

extension IncomeYearReducer.State {
    private func calculateYearlyIncomeTotal(from incomes: [Income]) -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        let yearlyTotal = incomes
            .filter { $0.year == currentYear }
            .reduce(0) { $0 + $1.amount }
        return yearlyTotal
    }
}
