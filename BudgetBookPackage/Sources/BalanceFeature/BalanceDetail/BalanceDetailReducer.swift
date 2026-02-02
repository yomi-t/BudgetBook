import ComposableArchitecture
import Core

@Reducer
public struct BalanceDetailReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {
        var balances: [Balance]
        public var balanceAccountListState: BalanceAccountListReducer.State
        public init(_ balances: [Balance]) {
            self.balances = balances.sorted { $0.amount > $1.amount }
            self.balanceAccountListState = BalanceAccountListReducer.State(balances: balances)
        }
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
        case balanceAccountListAction(BalanceAccountListReducer.Action)
        case updateBalances([Balance])
    }

    // MARK: - Dependencies
    @Dependency(\.balanceRepository)
    private var balanceRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Scope(state: \.balanceAccountListState, action: \.balanceAccountListAction) {
            BalanceAccountListReducer()
        }

        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .balanceAccountListAction(.delegate(.didDeleteBalance)):
                // 削除成功時に再フェッチ
                return .run { @MainActor [year = state.balances.first?.year ?? 0, month = state.balances.first?.month ?? 0] send in
                    do {
                        let datas = try await balanceRepository.fetchMonth(year, month)
                        send(.updateBalances(datas))
                    } catch {
                        print("Error fetching balances: \(error)")
                    }
                }

            case .updateBalances(let balances):
                state.balances = balances.sorted { $0.amount > $1.amount }
                state.balanceAccountListState = .init(balances: balances)
                return .none

            case .balanceAccountListAction:
                return .none
            }
        }
    }
}
