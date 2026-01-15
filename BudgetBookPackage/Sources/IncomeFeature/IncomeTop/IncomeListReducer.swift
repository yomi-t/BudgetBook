import ComposableArchitecture
import Core

@Reducer
public struct IncomeListReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var monthlyIncomes: [[Income]] = []
        public init(incomes: [Income] = []) {
            self.monthlyIncomes = groupIncomesByMonth(incomes)
        }
    }
    
    // MARK: - Action
    public enum Action: ViewAction {
        case view(ViewAction)
        case onTapDelete(Income)
        case delegate(Delegate)
        public enum ViewAction {
            case onAppear
        }
        public enum Delegate {
            case didDeleteIncome
        }
    }
    
    // MARK: - Dependencies
    @Dependency(\.incomeRepository)
    private var incomeRepository
    
    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .onTapDelete(let item):
                return .run { send in
                    do {
                        try await incomeRepository.delete(item)
                        print("deleted income: \(item)")
                        await send(.delegate(.didDeleteIncome))
                    } catch {
                        print("Error deleting income: \(error)")
                    }
                }

            case .delegate:
                return .none
            }
        }
    }
}

extension IncomeListReducer.State {
    private func groupIncomesByMonth(_ incomes: [Income]) -> [[Income]] {
        var monthlyList: [[Income]] = []
        for income in incomes {
            guard let latest = monthlyList.last?.first else {
                monthlyList.append([income])
                continue
            }
            if latest.yearMonth() == income.yearMonth() {
                monthlyList[monthlyList.count - 1].append(income)
            } else {
                monthlyList.append([income])
            }
        }
        return monthlyList.reversed()
    }
}
