import ComposableArchitecture
import Core

@Reducer
public struct IncomeGraphReducer {
    @ObservableState
    public struct State {
        public var graphData: [IncomeGraphModel]
        public var range: ClosedRange<Int>
        public init(incomeData: [Income]) {
            let gData = incomeData.convertToGraphData()
            self.graphData = gData
            self.range = gData.rangeAmount()
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
