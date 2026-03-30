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

    public enum Action: ViewAction, BindableAction, Sendable {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case updateSources([Source])
        public enum ViewAction: Sendable {
            case onAppear
            case onTapDeleteSource(Source)
            case showAddAlert(Bool)
            case onTapAddSource
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
                return .none
                
            case .view(.onTapAddSource):
                return .run { [addSourceName = state.addSourceName] send in
                    do {
                        try await sourceRepository.add(addSourceName)
                        let sources = await fetchSources()
                        await send(.updateSources(sources))
                    } catch {
                        print("Error adding source: \(error)")
                    }
                }

            case .view(.onTapDeleteSource(let source)):
                return .run { send in
                    do {
                        try await sourceRepository.delete(source)
                        let sources = await fetchSources()
                        await send(.updateSources(sources))
                    } catch {
                        print("Error deleting source: \(error)")
                    }
                }
                
            case .view(.showAddAlert(let isShow)):
                state.isShowAddAlert = isShow
                state.addSourceName = ""
                return .none
                
            case .binding:
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
