import ComposableArchitecture
import Core

@Reducer
public struct BalanceListReducer {
    // MARK: - State
    @ObservableState
    public struct State {
        public init(_ balances: [Balance] = []) {
            self.balances = balances
        }
        public var balances: [Balance] = []
    }
    
    // MARK: - Action
    public enum Action: ViewAction {
        case view(ViewAction)
        public enum ViewAction {
            case onAppear
        }
    }
    
    // MARK: - Dependencies
    public init() {
        // Dependencies
    }
    
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
