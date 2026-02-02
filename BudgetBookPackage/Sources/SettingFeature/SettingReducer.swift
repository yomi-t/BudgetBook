import ComposableArchitecture

@Reducer
public struct SettingReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {

        public init() {
            
        }
    }

    public enum Action: ViewAction {
        case view(ViewAction)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none
            }
        }
    }
}
