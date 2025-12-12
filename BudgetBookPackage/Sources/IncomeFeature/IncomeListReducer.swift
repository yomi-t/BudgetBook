import ComposableArchitecture
import Core

@Reducer
public struct IncomeListReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public init(incomes: [Income] = []) {
            self.incomes = incomes.reversed()
        }
        public var incomes: [Income] = []
    }
    
    // MARK: - Action
    public enum Action: ViewAction {
        case view(ViewAction)
        case onTapDelete(Income)
        case delegate(Delegate)
        public enum ViewAction {
            case onAppear
        }
        public enum Delegate {
            case didDeleteIncome
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.incomeRepository)
    private var incomeRepository
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .onTapDelete(let item):
                return .run { send in
                    do {
                        try await incomeRepository.delete(item)
                        print("deleted income: \(item)")
                        await send(.delegate(.didDeleteIncome))
                    } catch {
                        print("Error deleting income: \(error)")
                    }
                }

            case .delegate:
                return .none
            }
        }
    }
}
