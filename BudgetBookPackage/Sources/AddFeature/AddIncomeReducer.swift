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
        public var isSettingSheetPresented: Bool = false
        public var sourceSettingState = SourceSettingReducer.State()
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
        case sourceSetting(SourceSettingReducer.Action)
        case binding(BindingAction<State>)
        case updateSources([Source])

        public enum ViewAction: Sendable {
            case onAppear
            case tapAddBtn
            case tapSettingBtn
        }
    }

    // MARK: - Dependencies
    @Dependency(\.incomeRepository)
    private var incomeRepository

    public init() {}

    // MARK: - Reducer
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.sourceSettingState, action: \.sourceSetting) {
            SourceSettingReducer()
        }
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .none
                
            case .view(.tapAddBtn):
                guard let amount = state.amount, !state.sources.isEmpty else {
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
                
            case .view(.tapSettingBtn):
                state.isSettingSheetPresented = true
                return .none

            case .binding:
                return .none
                
            case .sourceSetting(.updateSources(let sources)):
                state.sources = sources
                state.sourceSettingState.sources = sources
                return .send(.updateSources(sources))

            case .sourceSetting:
                return .none
                
            case .updateSources(let sources):
                state.sources = sources
                state.sourceSettingState.sources = sources
                print("Sources updated: \(sources)")
                if sources.isEmpty {
                    state.source = "収入元を追加してください"
                } else {
                    state.source = sources[0].name
                }
                return .none
            }
        }
    }
}
