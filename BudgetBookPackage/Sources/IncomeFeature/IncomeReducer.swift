import ComposableArchitecture
import Core

@Reducer
public struct IncomeReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        
        public var incomes: [Income] = []
        public var incomeListState: IncomeListReducer.State

        public init() {
            self.incomeListState = IncomeListReducer.State()
        }
    }

    public enum Action: ViewAction {
        case view(ViewAction)
        case updateData([Income])
        case incomeListAction(IncomeListReducer.Action)
        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    @Dependency(\.incomeRepository)
    private var incomeRepository

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.incomeListState, action: \.incomeListAction) {
            IncomeListReducer()
        }

        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    do {
                        let datas = try await incomeRepository.fetchAll()
                        print("Fetched incomes: \(datas.count) items")
                        send(.updateData(datas))
                    } catch {
                        print("Error fetching incomes: \(error)")
                    }
                }

            case .updateData(let incomes):
                print("Updating state with \(incomes.count) incomes")
                state.incomes = incomes
                state.incomeListState.incomes = incomes.reversed()
                return .none

            case .incomeListAction(.delegate(.didDeleteIncome)):
                // 削除成功時に再フェッチ
                return .run { @MainActor send in
                    do {
                        let datas = try await incomeRepository.fetchAll()
                        send(.updateData(datas))
                    } catch {
                        print("Error fetching incomes after delete: \(error)")
                    }
                }

            case .incomeListAction:
                return .none
            }
        }
    }
}
