import ComposableArchitecture
import Core

public enum Tab: CaseIterable, Sendable {
    case home
    case balance
    case add
    case income
    case expense

    func iconName() -> String {
        switch self {
        case .home:
            return "house"

        case .balance:
            return "list.bullet"

        case .add:
            return "plus"

        case .income:
            return "dollarsign.circle"

        case .expense:
            return "cart"
        }
    }
    func tabName() -> String {
        switch self {
        case .home:
            return L10n.Tab.home

        case .balance:
            return L10n.Tab.asset

        case .add:
            return L10n.Tab.add

        case .income:
            return L10n.Tab.income

        case .expense:
            return L10n.Tab.expense
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
            case select(Tab)
        }
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

            case .view(.select(let tab)):
                state.selectedTab = tab
                return .none
            }
        }
    }
}
