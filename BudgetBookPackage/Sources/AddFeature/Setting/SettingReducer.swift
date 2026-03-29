import ComposableArchitecture

@Reducer
public struct SettingReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var accountSettingState = AccountSettingReducer.State()
        public var sourceSettingState = SourceSettingReducer.State()

        public init() {

        }
    }

    public enum Action: ViewAction, Sendable {
        case view(ViewAction)
        case accountSetting(AccountSettingReducer.Action)
        case sourceSetting(SourceSettingReducer.Action)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.accountSettingState, action: \.accountSetting) {
            AccountSettingReducer()
        }
        Scope(state: \.sourceSettingState, action: \.sourceSetting) {
            SourceSettingReducer()
        }
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .accountSetting:
                return .none

            case .sourceSetting:
                return .none
            }
        }
    }
}
