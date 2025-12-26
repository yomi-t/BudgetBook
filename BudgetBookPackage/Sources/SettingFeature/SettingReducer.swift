import ComposableArchitecture
import Core

@Reducer
public struct SettingReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        
        public var accounts: [Account] = []
        public var sources: [Source] = []
        public var isShowAddAccountAlert: Bool = false
        public var isShowAddSourceAlert: Bool = false

        public init() {
            
        }
    }

    public enum Action: ViewAction, BindableAction {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case onTapAddAccount(String)
        case onTapDeleteAccount(Account)
        case showAddAccountAlert(Bool)
        case updateAccounts([Account])
        case onTapAddSource(String)
        case onTapDeleteSource(Source)
        case showAddSourceAlert(Bool)
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

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    let accounts = await fetchAccounts()
                    print("Fetched accounts: \(accounts.count) items")
                    send(.updateAccounts(accounts))
                    
                    let sources = await fetchSources()
                    print("Fetched sources: \(sources.count) items")
                    send(.updateSources(sources))
                }
                
            case .binding:
                return .none
                
            case .onTapAddAccount(let accountName):
                return .run { @MainActor send in
                    do {
                        print("Adding account: \(accountName)")
                        try await accountRepository.add(accountName)
                        let accounts = await fetchAccounts()
                        send(.updateAccounts(accounts))
                    } catch {
                        print("Error adding account: \(error)")
                    }
                }
                
            case .onTapDeleteAccount(let account):
                return .run { @MainActor send in
                    do {
                        try await accountRepository.delete(account)
                        let accounts = await fetchAccounts()
                        send(.updateAccounts(accounts))
                    } catch {
                        print("Error deleting account: \(error)")
                    }
                }
                
            case .showAddAccountAlert(let isShow):
                state.isShowAddAccountAlert = isShow
                return .none
                
            case .updateAccounts(let accounts):
                print("Updating accounts: \(accounts.count) items")
                state.accounts = accounts
                return .none
                
            case .onTapAddSource(let sourceName):
                return .run { @MainActor send in
                    do {
                        try await sourceRepository.add(sourceName)
                        let sources = await fetchSources()
                        send(.updateSources(sources))
                    } catch {
                        print("Error adding source: \(error)")
                    }
                }
            
            case .onTapDeleteSource(let source):
                return .run { @MainActor send in
                    do {
                        try await sourceRepository.delete(source)
                        let sources = await fetchSources()
                        send(.updateSources(sources))
                    } catch {
                        print("Error deleting source: \(error)")
                    }
                }
                
            case .showAddSourceAlert(let isShow):
                state.isShowAddSourceAlert = isShow
                return .none
                    
            case .updateSources(let sources):
                state.sources = sources
                return .none
            }
        }
    }
}

extension SettingReducer {
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
    
    private func fetchSources() async -> [Source] {
        do {
            let sources = try await sourceRepository.fetchAll()
            return sources
        } catch {
            print("Error fetching sources: \(error)")
            return []
        }
    }
}
