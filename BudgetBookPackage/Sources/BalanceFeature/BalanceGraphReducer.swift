import ComposableArchitecture
import Core

@Reducer
public struct BalanceGraphReducer {
    @ObservableState
    public struct State {
        public var graphData: [BalanceGraphModel]
        public var range: ClosedRange<Int>
        public init(balanceData: [Balance]) {
            print("balanceData: \(balanceData)")
            let gData = balanceData.convertToGraphData()
            self.graphData = gData
            self.range = gData.rangeAmount()
            print("Graph Data: \(graphData), Range: \(range)")
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
