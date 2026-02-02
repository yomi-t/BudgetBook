import ComposableArchitecture
import Core
import Foundation
import HomeFeature
import Testing

@MainActor
private struct HomeFeatureTests {
    struct RelativeBalanceData: Sendable {
        let monthOffset: Int // 現在からの月のオフセット（-1 = 先月）
        let amounts: [Int] // 各アカウントの金額
    }

    struct UpdateDatasTestCase: Sendable {
        let previousMonthBalances: [Int] // 先々月の残高
        let lastMonthBalances: [Int] // 先月の残高
        let lastMonthIncomes: [Int] // 先月の収入
        let expectedLatestBalance: Int
        let expectedLatestIncome: Int
        let expectedLatestExpense: Int
    }

    func createBalances(
        previousMonth: (year: Int, month: Int),
        lastMonth: (year: Int, month: Int),
        previousBalances: [Int],
        lastBalances: [Int]
    ) -> [Balance] {
        var balances: [Balance] = []
        for (index, amount) in previousBalances.enumerated() {
            balances.append(Balance(
                id: "prev-\(index)",
                account: "アカウント\(index)",
                year: previousMonth.year,
                month: previousMonth.month,
                amount: amount
            ))
        }
        for (index, amount) in lastBalances.enumerated() {
            balances.append(Balance(
                id: "last-\(index)",
                account: "アカウント\(index)",
                year: lastMonth.year,
                month: lastMonth.month,
                amount: amount
            ))
        }
        return balances
    }

    func createIncomes(
        lastMonth: (year: Int, month: Int),
        amounts: [Int]
    ) -> [Income] {
        var incomes: [Income] = []
        for (index, amount) in amounts.enumerated() {
            incomes.append(Income(
                id: "income-\(index)",
                source: "収入源\(index)",
                year: lastMonth.year,
                month: lastMonth.month,
                amount: amount
            ))
        }
        return incomes
    }

    @Test(arguments: [
        UpdateDatasTestCase(
            previousMonthBalances: [50000, 100000],
            lastMonthBalances: [45000, 120000],
            lastMonthIncomes: [200000],
            expectedLatestBalance: 165000,
            expectedLatestIncome: 200000,
            expectedLatestExpense: 185000
        ),
        UpdateDatasTestCase(
            previousMonthBalances: [100000],
            lastMonthBalances: [80000],
            lastMonthIncomes: [150000],
            expectedLatestBalance: 80000,
            expectedLatestIncome: 150000,
            expectedLatestExpense: 170000
        ),
        UpdateDatasTestCase(
            previousMonthBalances: [50000],
            lastMonthBalances: [300000],
            lastMonthIncomes: [100000],
            expectedLatestBalance: 300000,
            expectedLatestIncome: 100000,
            expectedLatestExpense: 0
        ),
        UpdateDatasTestCase(
            previousMonthBalances: [100000],
            lastMonthBalances: [80000],
            lastMonthIncomes: [],
            expectedLatestBalance: 80000,
            expectedLatestIncome: 0,
            expectedLatestExpense: 20000
        ),
        UpdateDatasTestCase(
            previousMonthBalances: [],
            lastMonthBalances: [150000],
            lastMonthIncomes: [200000],
            expectedLatestBalance: 150000,
            expectedLatestIncome: 200000,
            expectedLatestExpense: 50000
        ),
        UpdateDatasTestCase(
            previousMonthBalances: [],
            lastMonthBalances: [],
            lastMonthIncomes: [],
            expectedLatestBalance: 0,
            expectedLatestIncome: 0,
            expectedLatestExpense: 0
        ),
        UpdateDatasTestCase(
            previousMonthBalances: [0],
            lastMonthBalances: [0],
            lastMonthIncomes: [0],
            expectedLatestBalance: 0,
            expectedLatestIncome: 0,
            expectedLatestExpense: 0
        ),
        UpdateDatasTestCase(
            previousMonthBalances: [100000, 50000],
            lastMonthBalances: [80000, 40000],
            lastMonthIncomes: [200000, 50000],
            expectedLatestBalance: 120000,
            expectedLatestIncome: 250000,
            expectedLatestExpense: 280000
        )
    ])
    func testUpdateDatas(_ testCase: UpdateDatasTestCase) async {
        let calendar = Calendar.current
        let now = Date()

        guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) else {
            Issue.record("Failed to calculate last month")
            return
        }
        let lastYear = calendar.component(.year, from: lastMonth)
        let lastMonthValue = calendar.component(.month, from: lastMonth)

        guard let twoMonthsAgo = calendar.date(byAdding: .month, value: -2, to: now) else {
            Issue.record("Failed to calculate two months ago")
            return
        }
        let twoMonthsAgoYear = calendar.component(.year, from: twoMonthsAgo)
        let twoMonthsAgoMonth = calendar.component(.month, from: twoMonthsAgo)

        let balances = createBalances(
            previousMonth: (twoMonthsAgoYear, twoMonthsAgoMonth),
            lastMonth: (lastYear, lastMonthValue),
            previousBalances: testCase.previousMonthBalances,
            lastBalances: testCase.lastMonthBalances
        )

        let incomes = createIncomes(
            lastMonth: (lastYear, lastMonthValue),
            amounts: testCase.lastMonthIncomes
        )

        let store = TestStore(initialState: HomeReducer.State()) {
            HomeReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateDatas(balances, incomes)) {
            $0.latestBalances = balances
            $0.latestBalance = testCase.expectedLatestBalance
            $0.latestIncome = testCase.expectedLatestIncome
            $0.latestExpense = testCase.expectedLatestExpense
        }
    }

    struct SetGoalTestCase: Sendable {
        let inputGoal: Int
        let expectedGoal: Int
    }

    @Test(arguments: [
        SetGoalTestCase(inputGoal: 5000000, expectedGoal: 5000000),
        SetGoalTestCase(inputGoal: 3000000, expectedGoal: 3000000),
        SetGoalTestCase(inputGoal: 10000000, expectedGoal: 10000000),
        SetGoalTestCase(inputGoal: 0, expectedGoal: 0),
        SetGoalTestCase(inputGoal: 1000, expectedGoal: 1000)
    ])
    func testSetGoal(_ testCase: SetGoalTestCase) async {
        let store = TestStore(initialState: HomeReducer.State()) {
            HomeReducer()
        }

        store.exhaustivity = .off

        await store.send(.binding(.set(\.inputGoal, testCase.inputGoal))) {
            $0.inputGoal = testCase.inputGoal
        }

        await store.send(.setGoal) {
            $0.goal = testCase.expectedGoal
        }
    }

    struct GoalCalculationTestCase: Sendable {
        let goal: Int
        let currentYearIncomes: [Int] // 今年の各月の収入
        let expectedToGoal: Int
    }

    @Test(arguments: [
        GoalCalculationTestCase(
            goal: 5000000,
            currentYearIncomes: [300000, 300000, 300000],
            expectedToGoal: 4100000
        ),
        GoalCalculationTestCase(
            goal: 3000000,
            currentYearIncomes: [250000],
            expectedToGoal: 2750000
        ),
        GoalCalculationTestCase(
            goal: 6000000,
            currentYearIncomes: [],
            expectedToGoal: 6000000
        ),
        GoalCalculationTestCase(
            goal: 2000000,
            currentYearIncomes: [200000, 200000, 200000, 200000, 200000],
            expectedToGoal: 1000000
        ),
        GoalCalculationTestCase(
            goal: 0,
            currentYearIncomes: [100000],
            expectedToGoal: -100000
        )
    ])
    func testGoalCalculation(_ testCase: GoalCalculationTestCase) async {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)

        var incomes: [Income] = []
        for (index, amount) in testCase.currentYearIncomes.enumerated() {
            incomes.append(Income(
                id: "income-\(index)",
                source: "給料",
                year: currentYear,
                month: index + 1,
                amount: amount
            ))
        }

        var initialState = HomeReducer.State()
        initialState.goal = testCase.goal

        let store = TestStore(initialState: initialState) {
            HomeReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateDatas([], incomes)) {
            $0.toGoal = testCase.expectedToGoal
            let leftMonths = incomes.leftMonthCount()
            $0.monthEstimate = testCase.expectedToGoal / leftMonths
        }
    }
}
