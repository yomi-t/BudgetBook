import ComposableArchitecture
import Core

@Reducer
public struct AddReducer: Sendable {
    
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init() {}
        public var selectedTab: AddTab = .balance
        public var balanceState = AddBalanceReducer.State()
        public var incomeState = AddIncomeReducer.State()
    }
    
    // MARK: - Action
    public enum Action: Sendable, ViewAction, BindableAction {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case balance(AddBalanceReducer.Action)
        case income(AddIncomeReducer.Action)
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
        BindingReducer()
        Scope(state: \.balanceState, action: \.balance) {
            AddBalanceReducer(balanceRepository: balanceRepository)
        }
        Scope(state: \.incomeState, action: \.income) {
            AddIncomeReducer(incomeRepository: incomeRepository)
        }
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .binding:
                return .none

            case .balance:
                return .none

            case .income:
                return .none
            }
        }
    }
    
    
    public enum AddTab: String, CaseIterable {
        case balance = "残高"
        case income = "収入"
    }
}
