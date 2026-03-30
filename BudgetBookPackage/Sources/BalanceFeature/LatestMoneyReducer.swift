import ComposableArchitecture
import Core
import Foundation

@Reducer
public struct LatestMoneyReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var latestMoney: Int = 0
        public init(balanceData: [Balance]) {
            self.latestMoney = calculateLatestMoney(from: balanceData)
        }
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
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

extension LatestMoneyReducer.State {
    private func calculateLatestMoney(from balances: [Balance]) -> Int {
        let calendar = Calendar.current
        guard let lastMonthDate = calendar.date(byAdding: .month, value: -1, to: Date()) else { return 0 }
        let lastYear = calendar.component(.year, from: lastMonthDate)
        let lastMonth = calendar.component(.month, from: lastMonthDate)
        return balances
            .filter { $0.year == lastYear && $0.month == lastMonth }
            .reduce(0) { $0 + $1.amount }
    }
}
