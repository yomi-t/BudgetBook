import ComposableArchitecture
import SharedModel

@Reducer
public struct IncomeListReducer {
    // MARK: - State
    @ObservableState
    public struct State {
        public init(incomes: [Income] = []) {
            self.incomes = incomes
        }
        public var incomes: [Income] = []
    }
    
    // MARK: - Action
    public enum Action: ViewAction {
        case view(ViewAction)
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
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                print(state.incomes)
                return .none
            }
        }
    }
}
