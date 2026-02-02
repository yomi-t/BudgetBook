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
        let lastMonth = Calendar.current.component(.month, from: Date()) - 1
        let year = lastMonth == 12 ? Calendar.current.component(.year, from: Date()) - 1 : Calendar.current.component(.year, from: Date())
        let latestBalances = balances
            .filter { $0.year == year && $0.month == lastMonth }
            .reduce(0) { $0 + $1.amount }
        return latestBalances
    }
}
