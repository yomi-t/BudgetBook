import ComposableArchitecture
import Foundation
import Repository
import SharedModel

@Reducer
public struct AddIncomeReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var amount: Int?
        public var sources: [String] = ["Life is Tech!", "Lumino", "リクルート", "dely"]
        public var source: String = "Life is Tech!"
        public var years: [String]
        public var months: [String]
        public var selectedMonth: Int
        public var selectedYear: Int
        init() {
            let currentYear = Calendar.current.component(.year, from: Date())
            let currentMonth = Calendar.current.component(.month, from: Date())
            // swiftlint:disable:next number_separator
            years = Array(1950...currentYear).reversed().map { String($0) }
            months = Array(1...12).map { String($0) }
            selectedYear = currentYear
            selectedMonth = currentMonth
        }
    }

    // MARK: - Action
    public enum Action: Sendable, ViewAction, BindableAction {
        case view(ViewAction)
        case binding(BindingAction<State>)
        case tapAddBtn

        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    private let incomeRepository: IncomeRepository

    public init(incomeRepository: IncomeRepository) {
        self.incomeRepository = incomeRepository
    }

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none

            case .binding:
                return .none

            case .tapAddBtn:
                guard let amount = state.amount else {
                    return .none
                }
                state.amount = nil
                return .run { [source = state.source, year = state.selectedYear, month = state.selectedMonth] _ in
                    await self.incomeRepository.add(
                        Income(
                            source: source,
                            year: year,
                            month: month,
                            amount: amount
                        )
                    )
                    print("Added income: \(amount), \(year), \(month), \(amount)")
                }
            }
        }
    }
}
