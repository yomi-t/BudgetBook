import ComposableArchitecture
import Core

@Reducer
public struct BalanceReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init() {
            self.balanceListState = BalanceListReducer.State()
        }
        public var balances: [Balance] = []
        public var balanceListState: BalanceListReducer.State
    }
    
    // MARK: - Action
    public enum Action: ViewAction {
        case view(ViewAction)
        case balanceListAction(BalanceListReducer.Action)
        case updateBalances([Balance])
        public enum ViewAction: Sendable {
            case onAppear
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.balanceRepository)
    private var balanceRepository
    
    public init() {}
    
    // MARK: - Reducer
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
                        send(.updateBalances(datas))
                    } catch {
                        print("Error fetching balances: \(error)")
                    }
                }
                
            case .balanceListAction(.delegate(.didDeleteBalance)):
                // 削除成功時に再フェッチ
                return .run { @MainActor send in
                    do {
                        let datas = try await balanceRepository.fetchAll()
                        send(.updateBalances(datas))
                    } catch {
                        print("Error fetching balances: \(error)")
                    }
                }
                
            case .updateBalances(let balances):
                state.balances = balances
                state.balanceListState.balances = balances.reversed()
                print("balances updated: \(balances)")
                return .none
                
            case .balanceListAction:
                return .none
            }
        }
    }
}
