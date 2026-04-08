import ComposableArchitecture
import Core
import Foundation
@Reducer
public struct AddBalanceReducer: Sendable {
    
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var years: [String]
        public var months: [String]
        public var selectedMonth: Int
        public var selectedYear: Int
        public var accounts: [Account] = []
        public var selectedAccount: String = ""
        public var amount: Int?
        public var isSettingSheetPresented: Bool = false
        public var accountSettingState = AccountSettingReducer.State()
        public init() {
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            // swiftlint:disable:next number_separator
            years = Array(1950...currentYear).reversed().map { String($0) }
            months = Array(1...12).map { String($0) }
            selectedYear = currentYear
            selectedMonth = currentMonth
        }
    }
    
    // MARK: - Action
    public enum Action: Sendable, ViewAction, BindableAction {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case updateAccounts([Account])
        case accountSetting(AccountSettingReducer.Action)
        public enum ViewAction: Sendable {
            case onAppear
            case tapAddBtn
            case tapSettingBtn
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.balanceRepository)
    private var balanceRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.accountSettingState, action: \.accountSetting) {
            AccountSettingReducer()
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
                
            case .view(.tapAddBtn):
                guard let amount = state.amount, !state.accounts.isEmpty else {
                    return .none
                }
                state.amount = nil
                return .run { [account = state.selectedAccount, year = state.selectedYear, month = state.selectedMonth] _ in
                    do {
                        try await balanceRepository.add(
                            Balance(
                                account: account,
                                year: year,
                                month: month,
                                amount: amount
                            )
                        )
                        print("Added balance: \(account), \(year), \(month), \(amount)")
                    } catch {
                        print("Error adding balance: \(error)")
                    }
                }
                
            case .view(.tapSettingBtn):
                state.isSettingSheetPresented = true
                return .none

            case .binding:
                return .none
                
            case .accountSetting(.updateAccounts(let accounts)):
                state.accounts = accounts
                state.accountSettingState.accounts = accounts
                return .send(.updateAccounts(accounts))

            case .accountSetting:
                return .none
                
            case .updateAccounts(let accounts):
                state.accounts = accounts
                state.accountSettingState.accounts = accounts
                print("Accounts updated: \(accounts)")
                if accounts.isEmpty {
                    state.selectedAccount = "口座を追加してください"
                } else {
                    state.selectedAccount = accounts[0].name
                }
                return .none
            }
        }
    }
}
