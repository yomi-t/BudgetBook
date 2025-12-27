import ComposableArchitecture
import Core

@Reducer
public struct BalanceReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init() {}
        public var balances: [Balance] = []
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
                state.balances = balances
                print("balances updated: \(balances)")
                return .none
            }
        }
    }
}
