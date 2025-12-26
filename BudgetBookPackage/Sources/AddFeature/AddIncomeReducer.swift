import ComposableArchitecture
import Core
import Foundation

@Reducer
public struct AddIncomeReducer: Sendable {
    // MARK: - State
    @ObservableState
    public struct State: Equatable {
        public var amount: Int?
        public var sources: [Source] = []
        public var source: String = ""
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
        case updateSources([Source])

        public enum ViewAction: Sendable {
            case onAppear
        }
    }

    // MARK: - Dependencies
    @Dependency(\.incomeRepository)
    private var incomeRepository
    
    @Dependency(\.sourceRepository)
    private var sourceRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { @MainActor send in
                    do {
                        let sources = try await sourceRepository.fetchAll()
                        send(.updateSources(sources))
                    } catch {
                        print("Error fetching sources: \(error)")
                    }
                }

            case .binding:
                return .none

            case .tapAddBtn:
                guard let amount = state.amount else {
                    return .none
                }
                state.amount = nil
                return .run { [source = state.source, year = state.selectedYear, month = state.selectedMonth] _ in
                    do {
                        try await incomeRepository.add(
                            Income(
                                source: source,
                                year: year,
                                month: month,
                                amount: amount
                            )
                        )
                        print("Added income: \(amount), \(year), \(month), \(amount)")
                    } catch {
                        print("Error adding income: \(error)")
                    }
                }
                
            case .updateSources(let sources):
                state.sources = sources
                print("Sources updated: \(sources)")
                if sources.isEmpty {
                    state.source = "収入源を追加してください"
                } else {
                    state.source = sources[0].name
                }
                return .none
            }
        }
    }
}
