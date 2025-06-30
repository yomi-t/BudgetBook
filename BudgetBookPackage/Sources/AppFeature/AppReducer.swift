import ComposableArchitecture

@Reducer
public struct AppReducer: Sendable {

    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var selectedTab: Tab
        var customTabState: CustomTabReducer.State

        public init(selectedTab: Tab = .home) {
            self.selectedTab = selectedTab
            self.customTabState = .init(selectedTab: .home)
        }
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        case customTabAction(CustomTabReducer.Action)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Scope(state: \.customTabState, action: \.customTabAction) {
            CustomTabReducer()
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .customTabAction(.select(let tab)):
                state.selectedTab = tab
                return .none

            default:
                return .none
            }
        }
    }

    // MARK: - Dependencies
    public init() {
        // Dependencies
    }
}
