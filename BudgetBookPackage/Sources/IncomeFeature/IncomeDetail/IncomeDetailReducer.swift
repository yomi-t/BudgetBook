import ComposableArchitecture
import Core

@Reducer
public struct IncomeDetailReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {
        var incomes: [Income]
        public var incomeSourceListState: IncomeSourceListReducer.State
        public init(_ incomes: [Income]) {
            self.incomes = incomes.sorted { $0.amount > $1.amount }
            self.incomeSourceListState = IncomeSourceListReducer.State(incomes: incomes)
        }
    }
    
    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
        case incomeSourceListAction(IncomeSourceListReducer.Action)
        case updateIncomes([Income])
    }
    
    // MARK: - Dependencies
    @Dependency(\.incomeRepository)
    private var incomeRepository
    
    public init() {}
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Scope(state: \.incomeSourceListState, action: \.incomeSourceListAction) {
            IncomeSourceListReducer()
        }

        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .incomeSourceListAction(.delegate(.didDeleteIncome)):
                // 削除成功時に再フェッチ
                return .run { @MainActor [year = state.incomes.first?.year ?? 0, month = state.incomes.first?.month ?? 0] send in
                    do {
                        let datas = try await incomeRepository.fetchMonth(year, month)
                        send(.updateIncomes(datas))
                    } catch {
                        print("Error fetching balances: \(error)")
                    }
                }

            case .updateIncomes(let incomes):
                state.incomes = incomes.sorted { $0.amount > $1.amount }
                state.incomeSourceListState = .init(incomes: incomes)
                return .none

            case .incomeSourceListAction:
                return .none
            }
        }
    }
}
