import ComposableArchitecture
import Core

@Reducer
public struct SourceSettingReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        
        public var sources: [Source] = []
        public var isShowAddAlert: Bool = false
        public var addSourceName: String = ""

        public init() {
            
        }
    }

    public enum Action: ViewAction, BindableAction {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case onTapAddSource
        case onTapDeleteSource(Source)
        case showAddAlert(Bool)
        case updateSources([Source])
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    @Dependency(\.sourceRepository)
    private var sourceRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    
                    let sources = await fetchSources()
                    print("Fetched sources: \(sources.count) items")
                    send(.updateSources(sources))
                }
                
            case .binding:
                return .none
                
            case .onTapAddSource:
                return .run { @MainActor [addSourceName = state.addSourceName] send in
                    do {
                        try await sourceRepository.add(addSourceName)
                        let sources = await fetchSources()
                        send(.updateSources(sources))
                    } catch {
                        print("Error adding source: \(error)")
                    }
                }
            
            case .onTapDeleteSource(let source):
                return .run { @MainActor send in
                    do {
                        try await sourceRepository.delete(source)
                        let sources = await fetchSources()
                        send(.updateSources(sources))
                    } catch {
                        print("Error deleting source: \(error)")
                    }
                }
                
            case .showAddAlert(let isShow):
                state.isShowAddAlert = isShow
                state.addSourceName = ""
                return .none
                    
            case .updateSources(let sources):
                state.sources = sources
                return .none
            }
        }
    }
}

extension SourceSettingReducer {
    private func fetchSources() async -> [Source] {
        do {
            let sources = try await sourceRepository.fetchAll()
            return sources
        } catch {
            print("Error fetching sources: \(error)")
            return []
        }
    }
}
