import ComposableArchitecture
import Core

@Reducer
public struct BalanceReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var balances: [Balance] = []
        public var balanceListState: BalanceListReducer.State
        public var path = StackState<Path.State>()

        public init() {
            self.balanceListState = BalanceListReducer.State()
        }
    }

    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        case updateBalances([Balance])
        case balanceListAction(BalanceListReducer.Action)
        case path(StackActionOf<Path>)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    @Dependency(\.balanceRepository)
    private var balanceRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.balanceListState, action: \.balanceListAction) {
            BalanceListReducer()
        }

        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    do {
                        let datas = try await balanceRepository.fetchAll()
                        print("Fetched balances: \(datas.count) items")
                        send(.updateBalances(datas))
                    } catch {
                        print("Error fetching balances: \(error)")
                    }
                }

            case .updateBalances(let balances):
                print("Updating state with \(balances.count) balances")
                state.balances = balances
                state.balanceListState = .init(balances: balances.reversed())
                return .none

            case .balanceListAction(.delegate(.didDeleteBalance)):
                // 削除成功時に再フェッチ
                return .run { @MainActor send in
                    do {
                        let datas = try await balanceRepository.fetchAll()
                        send(.updateBalances(datas))
                    } catch {
                        print("Error fetching balances after delete: \(error)")
                    }
                }

            case .balanceListAction(.delegate(.navigateToDetail(let balances))):
                state.path.append(.balanceDetail(BalanceDetailReducer.State(balances)))
                return .none

            case .balanceListAction:
                return .none

            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

    @Reducer
    public enum Path {
        case balanceDetail(BalanceDetailReducer)
    }
}

extension BalanceReducer.Path.State: Equatable, Sendable {}
extension BalanceReducer.Path.Action: Sendable {}
