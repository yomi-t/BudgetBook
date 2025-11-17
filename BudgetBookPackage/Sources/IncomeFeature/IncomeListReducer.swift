import ComposableArchitecture
import Core

@Reducer
public struct IncomeListReducer {
    // MARK: - State
    @ObservableState
    public struct State {
        public init(incomes: [Income] = []) {
            self.incomes = incomes.reversed()
        }
        public var incomes: [Income] = []
    }
    
    // MARK: - Action
    public enum Action: ViewAction {
        case view(ViewAction)
        case onTapDelete(Income)
        public enum ViewAction {
            case onAppear
        }
    }
    
    // MARK: - Dependencies
    public init() {
        // Dependencies
    }
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .onTapDelete(let item):
                return .none
            }
        }
    }
}
