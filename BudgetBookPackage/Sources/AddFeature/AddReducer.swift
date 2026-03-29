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
        public var settingState = SettingReducer.State()
        public var isSettingSheetPresented = false
        public var accounts: [Account] = []
        public var sources: [Source] = []
    }
    
    // MARK: - Action
    public enum Action: Sendable, ViewAction, BindableAction {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case balance(AddBalanceReducer.Action)
        case income(AddIncomeReducer.Action)
        case setting(SettingReducer.Action)
        case updateAccounts([Account])
        case updateSources([Source])
        public enum ViewAction: Sendable {
            case onAppear
            case settingButtonTapped
            case dismissSettingSheet
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
        Scope(state: \.settingState, action: \.setting) {
            SettingReducer()
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

            case .view(.settingButtonTapped):
                state.isSettingSheetPresented = true
                return .none

            case .view(.dismissSettingSheet):
                state.isSettingSheetPresented = false
                return .none

            case .binding:
                return .none

            case .balance:
                return .none

            case .income:
                return .none

            case .setting(.accountSetting(.updateAccounts(let accounts))):
                state.accounts = accounts
                state.settingState.accountSettingState.accounts = accounts
                return .send(.balance(.updateAccounts(accounts)))

            case .setting(.sourceSetting(.updateSources(let sources))):
                state.sources = sources
                state.settingState.sourceSettingState.sources = sources
                return .send(.income(.updateSources(sources)))

            case .setting:
                return .none

            case .updateAccounts(let accounts):
                state.accounts = accounts
                state.settingState.accountSettingState.accounts = accounts
                return .send(.balance(.updateAccounts(accounts)))

            case .updateSources(let sources):
                state.sources = sources
                state.settingState.sourceSettingState.sources = sources
                return .send(.income(.updateSources(sources)))
            }
        }
    }
    
    
    public enum AddTab: String, CaseIterable {
        case balance = "残高"
        case income = "収入"
    }
}
