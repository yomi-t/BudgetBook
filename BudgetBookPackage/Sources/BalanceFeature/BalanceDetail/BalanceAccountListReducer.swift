import ComposableArchitecture
import Core

@Reducer
public struct BalanceAccountListReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {
        public init(balances: [Balance]) {
            self.balances = balances
            self.year = balances.first?.year ?? 0
            self.month = balances.first?.month ?? 0
        }
        public var balances: [Balance] = []
        public let year: Int
        public let month: Int
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        case delegate(Delegate)
        public enum ViewAction: Sendable {
            case onAppear
            case onTapDelete(Balance)
        }
        public enum Delegate: Sendable {
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
                        print("deleted balance: \(item)")
                        await send(.delegate(.didDeleteBalance))
                    } catch {
                        print("Error deleting balance: \(error)")
                    }
                }

            case .delegate:
                return .none
            }
        }
    }
}
