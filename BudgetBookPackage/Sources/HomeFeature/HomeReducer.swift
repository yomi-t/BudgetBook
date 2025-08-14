import ComposableArchitecture
import Repository
import SharedModel

@Reducer
public struct HomeReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init() {}
        public var latestMoney: Int = 0
        public var latestBalances: [Balance] = []
    }

    // MARK: - Action
    public enum Action: ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
        case updateBalances([Balance])
    }

    // MARK: - Dependencies
    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    let datas = await BalanceRepository.shared.fetchLatestBalances()
                    send(.updateBalances(datas))
                }

            case .updateBalances(let balances):
                state.latestBalances = balances
                state.latestMoney = balances.reduce(0) { $0 + $1.amount }
                return .none
            }
        }
    }
}
