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
        public var accounts: [Account] = []
        public var sources: [Source] = []
    }
    
    // MARK: - Action
    public enum Action: Sendable, ViewAction, BindableAction {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case balance(AddBalanceReducer.Action)
        case income(AddIncomeReducer.Action)
        case updateAccounts([Account])
        case updateSources([Source])
        public enum ViewAction: Sendable {
            case onAppear
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.accountRepository)
    private var accountRepository

    @Dependency(\.sourceRepository)
    private var sourceRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.balanceState, action: \.balance) {
            AddBalanceReducer()
        }
        Scope(state: \.incomeState, action: \.income) {
            AddIncomeReducer()
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { send in
                    async let accounts = try accountRepository.fetchAll()
                    async let sources = try sourceRepository.fetchAll()
                    await send(.updateAccounts(try accounts))
                    await send(.updateSources(try sources))
                }

            case .binding:
                return .none

            case .balance:
                return .none

            case .income:
                return .none

            case .updateAccounts(let accounts):
                state.accounts = accounts
                return .send(.balance(.updateAccounts(accounts)))

            case .updateSources(let sources):
                state.sources = sources
                return .send(.income(.updateSources(sources)))
            }
        }
    }
    
    
    public enum AddTab: String, CaseIterable {
        case balance
        case income

        public var localizedName: String {
            switch self {
            case .balance:
                return L10n.Add.Tab.balance
            
            case .income:
                return L10n.Add.Tab.income
            }
        }
    }
}
