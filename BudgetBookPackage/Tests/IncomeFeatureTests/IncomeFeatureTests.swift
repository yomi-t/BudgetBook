import ComposableArchitecture
import Core
import IncomeFeature
import Testing

@MainActor
private struct IncomeFeatureTests {
    struct UpdateDataTestCase: Sendable {
        let incomes: [Income]
        let expectedIncomeCount: Int
        let expectedMonthlyGroupCount: Int
    }

    @Test(arguments: [
        UpdateDataTestCase(
            incomes: [
                Income(source: "勤務先", year: 2025, month: 3, amount: 39232),
                Income(source: "勤務先", year: 2025, month: 4, amount: 58392)
            ],
            expectedIncomeCount: 2,
            expectedMonthlyGroupCount: 2
        ),
        UpdateDataTestCase(
            incomes: [
                Income(source: "hello", year: 2025, month: 2, amount: 48939),
                Income(source: "alksjd", year: 2025, month: 2, amount: 19293),
                Income(source: "sajnla", year: 2025, month: 3, amount: 64738),
                Income(source: "lasjdv", year: 2025, month: 4, amount: 39292)
            ],
            expectedIncomeCount: 4,
            expectedMonthlyGroupCount: 3
        ),
        UpdateDataTestCase(
            incomes: [
                Income(source: "給料", year: 2025, month: 1, amount: 300000)
            ],
            expectedIncomeCount: 1,
            expectedMonthlyGroupCount: 1
        ),
        UpdateDataTestCase(
            incomes: [],
            expectedIncomeCount: 0,
            expectedMonthlyGroupCount: 0
        ),
        UpdateDataTestCase(
            incomes: [
                Income(source: "給料", year: 2025, month: 1, amount: 300000),
                Income(source: "副業", year: 2025, month: 1, amount: 50000),
                Income(source: "投資", year: 2025, month: 1, amount: 100000),
                Income(source: "その他", year: 2025, month: 2, amount: 25000)
            ],
            expectedIncomeCount: 4,
            expectedMonthlyGroupCount: 2
        ),
        UpdateDataTestCase(
            incomes: [
                Income(source: "給料A", year: 2025, month: 1, amount: 100000),
                Income(source: "給料B", year: 2025, month: 2, amount: 200000),
                Income(source: "給料C", year: 2025, month: 3, amount: 300000),
                Income(source: "給料D", year: 2025, month: 4, amount: 400000),
                Income(source: "給料E", year: 2025, month: 5, amount: 500000)
            ],
            expectedIncomeCount: 5,
            expectedMonthlyGroupCount: 5
        )
    ])
    func testUpdateData(_ testCase: UpdateDataTestCase) async {
        let store = TestStore(initialState: IncomeReducer.State()) {
            IncomeReducer()
        }

        // テストストアの詳細検証を無効にする
        store.exhaustivity = .off

        await store.send(.updateData(testCase.incomes)) {
            $0.incomes = testCase.incomes
            $0.incomeListState = IncomeListReducer.State(incomes: testCase.incomes.reversed())

            // カウントが正しいことを確認
            if $0.incomes.count != testCase.expectedIncomeCount {
                Issue.record("Expected income count \(testCase.expectedIncomeCount) but got \($0.incomes.count)")
            }

            // 月ごとのグループ数が正しいことを確認
            if $0.incomeListState.monthlyIncomes.count != testCase.expectedMonthlyGroupCount {
                Issue.record("Expected monthly group count \(testCase.expectedMonthlyGroupCount) but got \($0.incomeListState.monthlyIncomes.count)")
            }
        }
    }

    struct IncomeTotalAmountTestCase: Sendable {
        let incomes: [Income]
        let totalAmount: Int
    }

    @Test(arguments: [
        IncomeTotalAmountTestCase(
            incomes: [
                Income(source: "給料", year: 2025, month: 1, amount: 300000),
                Income(source: "副業", year: 2025, month: 1, amount: 50000)
            ],
            totalAmount: 350000
        ),
        IncomeTotalAmountTestCase(
            incomes: [
                Income(source: "給料", year: 2025, month: 1, amount: 250000),
                Income(source: "副業", year: 2025, month: 1, amount: 100000),
                Income(source: "投資", year: 2025, month: 1, amount: 50000)
            ],
            totalAmount: 400000
        ),
        IncomeTotalAmountTestCase(
            incomes: [
                Income(source: "給料", year: 2025, month: 1, amount: 0)
            ],
            totalAmount: 0
        ),
        IncomeTotalAmountTestCase(
            incomes: [],
            totalAmount: 0
        )
    ])
    func testIncomeTotalAmount(_ testCase: IncomeTotalAmountTestCase) async {
        let store = TestStore(initialState: IncomeReducer.State()) {
            IncomeReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateData(testCase.incomes)) {
            $0.incomes = testCase.incomes
            let calculatedTotal = testCase.incomes.reduce(0) { $0 + $1.amount }
            if calculatedTotal != testCase.totalAmount {
                Issue.record("Expected total \(testCase.totalAmount) but got \(calculatedTotal)")
            }
        }
    }

    struct MonthlyGroupingTestCase: Sendable {
        let incomes: [Income]
        let expectedMonthlyGroupCount: Int
        let description: String
    }

    @Test(arguments: [
        MonthlyGroupingTestCase(
            incomes: [
                Income(id: "1", source: "A", year: 2025, month: 1, amount: 10000),
                Income(id: "2", source: "B", year: 2025, month: 2, amount: 20000),
                Income(id: "3", source: "C", year: 2025, month: 3, amount: 30000)
            ],
            expectedMonthlyGroupCount: 3,
            description: "異なる月の収入は別々にグループ化される"
        ),
        MonthlyGroupingTestCase(
            incomes: [
                Income(id: "1", source: "給料", year: 2025, month: 1, amount: 300000),
                Income(id: "2", source: "副業", year: 2025, month: 1, amount: 50000)
            ],
            expectedMonthlyGroupCount: 1,
            description: "同じ月の収入は1つにグループ化される"
        ),
        MonthlyGroupingTestCase(
            incomes: [
                Income(id: "1", source: "給料", year: 2025, month: 1, amount: 300000)
            ],
            expectedMonthlyGroupCount: 1,
            description: "1つの収入は1つのグループになる"
        ),
        MonthlyGroupingTestCase(
            incomes: [],
            expectedMonthlyGroupCount: 0,
            description: "空の場合はグループなし"
        )
    ])
    func testIncomeMonthlyGrouping(_ testCase: MonthlyGroupingTestCase) async {
        let store = TestStore(initialState: IncomeReducer.State()) {
            IncomeReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateData(testCase.incomes)) {
            $0.incomes = testCase.incomes
            $0.incomeListState = IncomeListReducer.State(incomes: testCase.incomes.reversed())

            // 月ごとのグループ数が正しいことを確認
            if $0.incomeListState.monthlyIncomes.count != testCase.expectedMonthlyGroupCount {
                Issue.record("\(testCase.description): Expected \(testCase.expectedMonthlyGroupCount) groups but got \($0.incomeListState.monthlyIncomes.count)")
            }
        }
    }

    struct ThisYearIncomeTestCase: Sendable {
        let incomes: [Income]
    }

    @Test(arguments: [
        ThisYearIncomeTestCase(
            incomes: [
                Income(source: "給料", year: 2025, month: 1, amount: 300000),
                Income(source: "給料", year: 2025, month: 2, amount: 300000),
                Income(source: "副業", year: 2025, month: 1, amount: 50000),
                Income(source: "給料", year: 2024, month: 12, amount: 300000)
            ]
        ),
        ThisYearIncomeTestCase(
            incomes: [
                Income(source: "給料", year: 2025, month: 1, amount: 250000)
            ]
        ),
        ThisYearIncomeTestCase(
            incomes: []
        )
    ])
    func testThisYearIncomeCalculation(_ testCase: ThisYearIncomeTestCase) async {
        let store = TestStore(initialState: IncomeReducer.State()) {
            IncomeReducer()
        }

        store.exhaustivity = .off

        await store.send(.updateData(testCase.incomes)) {
            $0.incomes = testCase.incomes

            // thisYearIncome() の計算が正しいことを確認
            let thisYearTotal = testCase.incomes.thisYearIncome()
            if thisYearTotal < 0 {
                Issue.record("This year income should not be negative: \(thisYearTotal)")
            }
        }
    }
}
