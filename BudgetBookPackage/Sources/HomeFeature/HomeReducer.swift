import ComposableArchitecture

@Reducer
public struct HomeReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init() {}
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
