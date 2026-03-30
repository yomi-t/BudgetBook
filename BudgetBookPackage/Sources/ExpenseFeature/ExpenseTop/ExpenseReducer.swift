import ComposableArchitecture
import Core

@Reducer
public struct ExpenseReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var balances: [Balance] = []
        public var incomes: [Income] = []
        public var expenseListState: ExpenseListReducer.State
        public var expenseGraphState: ExpenseGraphReducer.State
        public var expenseYearState: ExpenseYearReducer.State

        public init() {
            self.expenseListState = ExpenseListReducer.State()
            self.expenseGraphState = ExpenseGraphReducer.State()
            self.expenseYearState = ExpenseYearReducer.State()
        }
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        case updateBalances([Balance])
        case updateIncomes([Income])
        case expenseListAction(ExpenseListReducer.Action)
        case expenseGraphAction(ExpenseGraphReducer.Action)
        case expenseYearAction(ExpenseYearReducer.Action)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    @Dependency(\.balanceRepository)
    private var balanceRepository
    @Dependency(\.incomeRepository)
    private var incomeRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Scope(state: \.expenseListState, action: \.expenseListAction) {
            ExpenseListReducer()
        }
        Scope(state: \.expenseGraphState, action: \.expenseGraphAction) {
            ExpenseGraphReducer()
        }
        Scope(state: \.expenseYearState, action: \.expenseYearAction) {
            ExpenseYearReducer()
        }

        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .merge(
                    .run { send in
                        do {
                            let data = try await balanceRepository.fetchAll()
                            await send(.updateBalances(data))
                        } catch {
                            print("Error fetching balances: \(error)")
                        }
                    },
                    .run { send in
                        do {
                            let data = try await incomeRepository.fetchAll()
                            await send(.updateIncomes(data))
                        } catch {
                            print("Error fetching incomes: \(error)")
                        }
                    }
                )

            case .updateBalances(let balances):
                state.balances = balances
                state.expenseListState = .init(balances: state.balances, incomes: state.incomes)
                state.expenseGraphState = .init(balances: state.balances, incomes: state.incomes)
                state.expenseYearState = .init(balances: state.balances, incomes: state.incomes)
                return .none

            case .updateIncomes(let incomes):
                state.incomes = incomes
                state.expenseListState = .init(balances: state.balances, incomes: state.incomes)
                state.expenseGraphState = .init(balances: state.balances, incomes: state.incomes)
                state.expenseYearState = .init(balances: state.balances, incomes: state.incomes)
                return .none

            case .expenseListAction, .expenseGraphAction, .expenseYearAction:
                return .none
            }
        }
    }
}
