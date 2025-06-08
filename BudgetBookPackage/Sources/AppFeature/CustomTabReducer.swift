import ComposableArchitecture

public enum Tab: CaseIterable, Sendable {
    case home
    case leftMoney
    case add
    case leftMoneyList
    case settings

    func iconName() -> String {
        switch self {
        case .home:
            return "house"

        case .leftMoney:
            return "dollarsign.circle"

        case .add:
            return "plus"

        case .leftMoneyList:
            return "list.bullet"

        case .settings:
            return "gear"
        }
    }
    func tabName() -> String {
        switch self {
        case .home:
            return "Home"

        case .leftMoney:
            return "Left"

        case .add:
            return "Add"

        case .leftMoneyList:
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
