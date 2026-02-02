import ComposableArchitecture
import Core

@Reducer
public struct IncomeSourceListReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {
        public init(incomes: [Income]) {
            self.incomes = incomes
            self.year = incomes.first?.year ?? 0
            self.month = incomes.first?.month ?? 0
        }
        public var incomes: [Income] = []
        public let year: Int
        public let month: Int
    }
    
    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        case delegate(Delegate)
        public enum ViewAction: Sendable {
            case onAppear
            case onTapDelete(Income)
        }
        public enum Delegate: Sendable {
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

            case .view(.onTapDelete(let item)):
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
