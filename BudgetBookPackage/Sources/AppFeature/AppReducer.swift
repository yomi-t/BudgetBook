import AddFeature
import ComposableArchitecture
import Core

@Reducer
public struct AppReducer: Sendable {

    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var selectedTab: Tab
        var customTabState: CustomTabReducer.State
        var addState: AddReducer.State

        public init(selectedTab: Tab = .home) {
            self.selectedTab = selectedTab
            self.customTabState = .init(selectedTab: selectedTab)
            self.addState = .init()
        }
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        case customTabAction(CustomTabReducer.Action)
        case addAction(AddReducer.Action)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    private let balanceRepository: BalanceRepository
    private let incomeRepository: IncomeRepository

    public init(balanceRepository: BalanceRepository, incomeRepository: IncomeRepository) {
        self.balanceRepository = balanceRepository
        self.incomeRepository = incomeRepository
    }

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Scope(state: \.customTabState, action: \.customTabAction) {
            CustomTabReducer()
        }
        Scope(state: \.addState, action: \.addAction) {
            AddReducer(balanceRepository: balanceRepository, incomeRepository: incomeRepository)
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .customTabAction(.select(let tab)):
                state.selectedTab = tab
                return .none

            case .addAction:
                return .none

            default:
                return .none
            }
        }
    }
}
