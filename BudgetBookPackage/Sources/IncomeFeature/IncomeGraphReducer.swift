import ComposableArchitecture

@Reducer
public struct IncomeGraphReducer {
    @ObservableState
    public struct State {
        public var graphData: [IncomeGraphModel]
        public init(graphData: [IncomeGraphModel]) {
            self.graphData = graphData
        }
    }
    
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none
            }
        }
    }
    
    public init() {
        
    }
}
