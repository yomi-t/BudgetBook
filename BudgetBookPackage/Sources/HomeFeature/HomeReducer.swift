import ComposableArchitecture
import Core

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
    @Dependency(\.balanceRepository)
    private var balanceRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    do {
                        let datas = try await balanceRepository.fetchLatestBalances()
                        send(.updateBalances(datas))
                    } catch {
                        print("Error fetching balances: \(error)")
                    }
                }

            case .updateBalances(let balances):
                state.latestBalances = balances
                state.latestMoney = balances.reduce(0) { $0 + $1.amount }
                return .none
            }
        }
    }
}
