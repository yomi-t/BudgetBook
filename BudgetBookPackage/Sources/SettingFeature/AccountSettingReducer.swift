import ComposableArchitecture
import Core

@Reducer
public struct AccountSettingReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        
        public var accounts: [Account] = []
        public var addAccountName: String = ""
        public var isShowAddAlert: Bool = false

        public init() {
            
        }
    }

    public enum Action: ViewAction, BindableAction {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case updateAccounts([Account])
        public enum ViewAction: Sendable {
            case onAppear
            case onTapDeleteAccount(Account)
            case showAddAlert(Bool)
            case onTapAddAccount
        }
    }

    // MARK: - Dependencies
    @Dependency(\.accountRepository)
    private var accountRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    let accounts = await fetchAccounts()
                    print("Fetched accounts: \(accounts.count) items")
                    send(.updateAccounts(accounts))
                }
                
            case .view(.onTapAddAccount):
                return .run { @MainActor [addAccountName = state.addAccountName] send in
                    do {
                        try await accountRepository.add(addAccountName)
                        let accounts = await fetchAccounts()
                        send(.updateAccounts(accounts))
                    } catch {
                        print("Error adding account: \(error)")
                    }
                }
                
            case .view(.onTapDeleteAccount(let account)):
                return .run { @MainActor send in
                    do {
                        try await accountRepository.delete(account)
                        let accounts = await fetchAccounts()
                        send(.updateAccounts(accounts))
                    } catch {
                        print("Error deleting account: \(error)")
                    }
                }
                
            case .view(.showAddAlert(let isShow)):
                state.isShowAddAlert = isShow
                state.addAccountName = ""
                return .none
                
            case .binding:
                return .none
                
            case .updateAccounts(let accounts):
                print("Updating accounts: \(accounts.count) items")
                state.accounts = accounts
                return .none
            }
        }
    }
}

extension AccountSettingReducer {
    private func fetchAccounts() async -> [Account] {
        do {
            let accounts = try await accountRepository.fetchAll()
            print("Fetched accounts inside fetchAccounts: \(accounts.count) items")
            return accounts
        } catch {
            print("Error fetching accounts: \(error)")
            return []
        }
    }
}
