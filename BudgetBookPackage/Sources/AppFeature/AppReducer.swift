import AddFeature
import ComposableArchitecture
import Core
import IncomeFeature

@Reducer
public struct AppReducer: Sendable {

    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        var customTabState: CustomTabReducer.State
        var addState: AddReducer.State
        var incomeState: IncomeReducer.State
        var page: Page

        public init(selectedTab: Tab = .home) {
            self.customTabState = .init(selectedTab: selectedTab)
            self.addState = .init()
            self.incomeState = IncomeReducer.State()
            self.page = .home
        }
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        case customTabAction(CustomTabReducer.Action)
        case addAction(AddReducer.Action)
        case incomeAction(IncomeReducer.Action)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Scope(state: \.customTabState, action: \.customTabAction) {
            CustomTabReducer()
        }
        Scope(state: \.addState, action: \.addAction) {
            AddReducer()
        }
        Scope(state: \.incomeState, action: \.incomeAction) {
            IncomeReducer()
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .customTabAction(.select(let tab)):
                switch tab {
                case .home:
                    state.page = .home
                    
                case .balance:
                    state.page = .balance
                    
                case .add:
                    state.page = .add
                    
                case .income:
                    state.page = .income
                    
                case .settings:
                    state.page = .settings
                }
                return .none

            case .addAction:
                return .none
                
            case .incomeAction(.incomeListAction(.delegate(.navigateToDetail(let incomes)))):
                state.page = .incomeDetail(incomes)
                return .none

            default:
                return .none
            }
        }
    }
}
