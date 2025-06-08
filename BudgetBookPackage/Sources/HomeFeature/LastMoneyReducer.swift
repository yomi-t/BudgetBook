import ComposableArchitecture

@Reducer
public struct LastMoneyReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init(lastMoney: Int = 0) {
            self.lastMoney = lastMoney
        }

        public var lastMoney: Int
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
