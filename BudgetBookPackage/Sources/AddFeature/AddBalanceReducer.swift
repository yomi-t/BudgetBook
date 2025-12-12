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
        public var accounts: [String] = ["三井住友", "三菱UFJ", "ゆうちょ銀行"]
        public var selectedAccount: String = "三井住友"
        public var amount: Int?
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
        case tapAddBtn
        public enum ViewAction: Sendable {
            case onAppear
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.balanceRepository)
    private var balanceRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .binding:
                return .none

            case .tapAddBtn:
                guard let amount = state.amount else {
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
            }
        }
    }
}
