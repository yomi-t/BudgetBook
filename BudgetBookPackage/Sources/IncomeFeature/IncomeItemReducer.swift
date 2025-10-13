import ComposableArchitecture
import SharedModel

@Reducer
public struct IncomeItemReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State {
        public init(item: Income) {
            self.item = item
        }
        public let item: Income
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
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                print(state.item)
                return .none
            }
        }
    }
}
