import ComposableArchitecture
import Core

@Reducer
public struct BalanceListReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init(balances: [Balance] = []) {
            self.balances = balances.reversed()
        }
        public var balances: [Balance] = []
    }
    
    // MARK: - Action
    public enum Action: ViewAction {
        case view(ViewAction)
        case delegate(Delegate)
        public enum ViewAction {
            case onAppear
            case onTapDelete(Balance)
        }
        public enum Delegate {
            case didDeleteBalance
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.balanceRepository)
    private var balanceRepository
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .view(.onTapDelete(let item)):
                return .run { send in
                    do {
                        try await balanceRepository.delete(item)
                        print("deleted income: \(item)")
                        await send(.delegate(.didDeleteBalance))
                    } catch {
                        print("Error deleting income: \(error)")
                    }
                }

            case .delegate:
                return .none
            }
        }
    }
}
