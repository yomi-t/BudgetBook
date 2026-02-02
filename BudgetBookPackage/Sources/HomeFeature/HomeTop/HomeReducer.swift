import ComposableArchitecture
import Core
import Foundation

@Reducer
public struct HomeReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init() {
            let goal = UserDefaultsManager.get(forKey: .goal)
            self.goal = goal
            inputGoal = goal
        }
        public var latestBalance = 0
        public var latestIncome = 0
        public var latestExpense = 0
        public var goal = 0
        public var toGoal = 0
        public var inputGoal = 0
        public var monthEstimate = 0
        public var latestBalances: [Balance] = []
        public var path = StackState<Path.State>()
    }

    // MARK: - Action
    public enum Action: ViewAction, BindableAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
        case binding(BindingAction<State>)
        case updateDatas([Balance], [Income])
        case path(StackActionOf<Path>)
        case setGoal
    }

    // MARK: - Dependencies
    @Dependency(\.balanceRepository)
    private var balanceRepository
    
    @Dependency(\.incomeRepository)
    private var incomeRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    do {
                        let balanceData = try await balanceRepository.fetchAll()
                        let incomeData = try await incomeRepository.fetchAll()
                        send(.updateDatas(balanceData, incomeData))
                    } catch {
                        print("Error fetching balances: \(error)")
                    }
                }
                
            case .binding:
                return .none

            case let .updateDatas(balances, incomes):
                state.latestBalances = balances
                state.latestBalance = balances.latestBalance()
                state.latestIncome = incomes.latestIncome()
                state.latestExpense = ExpenseManager().latestExpense(balances: balances, incomes: incomes)
                state.toGoal = state.goal - incomes.thisYearIncome()
                state.monthEstimate = (state.goal - incomes.thisYearIncome()) / incomes.leftMonthCount()
                return .none

            case .path:
                return .none
                
            case .setGoal:
                state.goal = state.inputGoal
                UserDefaultsManager.set(state.inputGoal, forKey: .goal)
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

    @Reducer
    public enum Path {
        // 遷移先が決まったらここに追加
    }
}

extension HomeReducer.Path.State: Equatable, Sendable {}
extension HomeReducer.Path.Action: Sendable {}
