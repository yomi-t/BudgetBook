import ComposableArchitecture
import Core

@Reducer
public struct IncomeGraphReducer {
    @ObservableState
    public struct State {
        public var graphData: [IncomeGraphModel]
        public var range: ClosedRange<Int>
        public init(incomeData: [Income]) {
            let gData = {
                // Group by (year, month) and sum amounts
                var data: [IncomeGraphModel] = []
                for item in incomeData {
                    if let sameMonthIndex = data.firstIndex(where: { $0.yearMonth == item.displayMonth() }) {
                        data[sameMonthIndex].amount += item.amount
                    } else {
                        data.append(.init(item))
                    }
                }
                // Sort by year then month for stable graph order
                return data.sorted { (lhs: IncomeGraphModel, rhs: IncomeGraphModel) -> Bool in
                    if lhs.year() == rhs.year() {
                        return lhs.month() < rhs.month()
                    }
                    return lhs.year() < rhs.year()
                }
            }()
            self.graphData = gData
            let minValue = max((gData.map { $0.amount }.min() ?? 0) - 10000, 0)
            let maxValue = (gData.map { $0.amount }.max() ?? 0) + 10000
            self.range = minValue...maxValue
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
