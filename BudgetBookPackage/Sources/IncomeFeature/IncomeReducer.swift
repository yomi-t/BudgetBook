import ComposableArchitecture
import Repository
import SharedModel

@Reducer
public struct IncomeReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var incomes: [Income] = []
        public var graphData: [IncomeGraphModel] = []
        public init() {}
    }
    
    public enum Action: ViewAction {
        case view(ViewAction)
        case updateData([Income])
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    private var incomeRepository: IncomeRepository

    public init(incomeRepository: IncomeRepository) {
        self.incomeRepository = incomeRepository
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    let datas = await incomeRepository.fetchAllIncomes()
                    print("Fetched incomes: \(datas.count) items")
                    send(.updateData(datas))
                }

            case .updateData(let incomes):
                print("Updating state with \(incomes.count) incomes")
                state.incomes = incomes
                state.graphData = incomes.map{IncomeGraphModel(id: $0.id, yearMonth: $0.yearMonth(), amount: $0.amount)}
                return .none
            }
        }
    }
}
