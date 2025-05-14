import ComposableArchitecture
import SharedModel

@Reducer
public struct LeftMoneyItemReducer: Sendable {
    
    //MARK: - State
    @ObservableState
    public struct State {
        public init(item: LeftMoneyItem) {
            self.item = item
        }
        public let item: LeftMoneyItem
    }
    
    //MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }
    
    //MARK: - Dependencies
    public init() {}
    
    //MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none
            }
        }
    }
}
