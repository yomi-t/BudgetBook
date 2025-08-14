import ComposableArchitecture
import SharedModel

@Reducer
public struct BalanceItemReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State {
        public init(item: Balance) {
            self.item = item
        }
        public let item: Balance
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
