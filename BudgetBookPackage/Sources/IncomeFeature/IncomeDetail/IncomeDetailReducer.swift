import ComposableArchitecture
import Core

@Reducer
public struct IncomeDetailReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable, Sendable {
        var incomes: [Income]
        public init(_ incomes: [Income]) {
            self.incomes = incomes.sorted { $0.amount > $1.amount }
        }
    }
    
    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.incomeRepository)
    private var incomeRepository
    
    public init() {}
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none

            }
        }
    }
}
