import ComposableArchitecture

public enum Tab: CaseIterable, Sendable {
    case home
    case balance
    case add
    case balanceList
    case settings

    func iconName() -> String {
        switch self {
        case .home:
            return "house"

        case .balance:
            return "dollarsign.circle"

        case .add:
            return "plus"

        case .balanceList:
            return "list.bullet"

        case .settings:
            return "gear"
        }
    }
    func tabName() -> String {
        switch self {
        case .home:
            return "Home"

        case .balance:
            return "Left"

        case .add:
            return "Add"

        case .balanceList:
            return "Left List"

        case .settings:
            return "Settings"
        }
    }
}

@Reducer
public struct CustomTabReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var selectedTab: Tab
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
        case select(Tab)
    }

    // MARK: - Dependencies
    public init() {
        // Dependencies
    }

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .select(let tab):
                state.selectedTab = tab
                return .none
            }
        }
    }
}
