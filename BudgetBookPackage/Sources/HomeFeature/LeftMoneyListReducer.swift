import ComposableArchitecture
import SharedModel

@Reducer
public struct LeftMoneyListReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State {
        public init(testData _: [LeftMoneyItem] = []) {}
        public let testData: [LeftMoneyItem] = [
            LeftMoneyItem(id: "a", title: "三井住友", amount: 300_140),
            LeftMoneyItem(id: "b", title: "三菱UFJ", amount: 92_991)
        ]
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
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
            }
        }
    }
}
