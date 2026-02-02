import Core
import Foundation
import Testing

private struct ExpenseManagerCalculateTests {
    let manager = ExpenseManager()

    struct CalculateExpenseTestCase: Sendable {
        let previousMonthBalances: [Int]
        let currentMonthBalances: [Int]
        let currentMonthIncomes: [Int]
        let expectedExpense: Int
        let description: String
    }

    func createTestBalances(
        previousMonth: (year: Int, month: Int),
        currentMonth: (year: Int, month: Int),
        previousBalances: [Int],
        currentBalances: [Int]
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
        for (index, amount) in currentBalances.enumerated() {
            balances.append(Balance(
                id: "current-\(index)",
                account: "アカウント\(index)",
                year: currentMonth.year,
                month: currentMonth.month,
                amount: amount
            ))
        }
        return balances
    }

    func createTestIncomes(
        currentMonth: (year: Int, month: Int),
        amounts: [Int]
    ) -> [Income] {
        var incomes: [Income] = []
        for (index, amount) in amounts.enumerated() {
            incomes.append(Income(
                id: "income-\(index)",
                source: "収入源\(index)",
                year: currentMonth.year,
                month: currentMonth.month,
                amount: amount
            ))
        }
        return incomes
    }

    @Test(arguments: [
        CalculateExpenseTestCase(
            previousMonthBalances: [50000, 100000],
            currentMonthBalances: [45000, 120000],
            currentMonthIncomes: [200000],
            expectedExpense: 185000,
            description: "通常の支出計算"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [50000],
            currentMonthBalances: [45000],
            currentMonthIncomes: [200000, 50000],
            expectedExpense: 255000,
            description: "複数の収入がある場合"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [100000],
            currentMonthBalances: [80000],
            currentMonthIncomes: [150000],
            expectedExpense: 170000,
            description: "残高が減少する場合"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [50000],
            currentMonthBalances: [300000],
            currentMonthIncomes: [100000],
            expectedExpense: 0,
            description: "支出がマイナスになる場合は0を返す"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [100000],
            currentMonthBalances: [80000],
            currentMonthIncomes: [],
            expectedExpense: 20000,
            description: "収入がない場合"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [],
            currentMonthBalances: [],
            currentMonthIncomes: [200000],
            expectedExpense: 200000,
            description: "残高がない場合"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [],
            currentMonthBalances: [150000],
            currentMonthIncomes: [200000],
            expectedExpense: 50000,
            description: "前月の残高がない場合"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [0],
            currentMonthBalances: [0],
            currentMonthIncomes: [0],
            expectedExpense: 0,
            description: "すべてが0の場合"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [],
            currentMonthBalances: [],
            currentMonthIncomes: [],
            expectedExpense: 0,
            description: "すべて空の場合"
        ),
        CalculateExpenseTestCase(
            previousMonthBalances: [100000, 50000],
            currentMonthBalances: [80000, 40000],
            currentMonthIncomes: [200000, 50000],
            expectedExpense: 280000,
            description: "複数のアカウントと複数の収入"
        )
    ])
    func testCalculateExpense(_ testCase: CalculateExpenseTestCase) {
        let calendar = Calendar.current
        let now = Date()

        guard let currentMonth = calendar.date(byAdding: .month, value: -1, to: now) else {
            Issue.record("Failed to calculate current month")
            return
        }
        let currentYear = calendar.component(.year, from: currentMonth)
        let currentMonthValue = calendar.component(.month, from: currentMonth)

        guard let previousMonth = calendar.date(byAdding: .month, value: -2, to: now) else {
            Issue.record("Failed to calculate previous month")
            return
        }
        let previousYear = calendar.component(.year, from: previousMonth)
        let previousMonthValue = calendar.component(.month, from: previousMonth)

        let balances = createTestBalances(
            previousMonth: (previousYear, previousMonthValue),
            currentMonth: (currentYear, currentMonthValue),
            previousBalances: testCase.previousMonthBalances,
            currentBalances: testCase.currentMonthBalances
        )

        let incomes = createTestIncomes(
            currentMonth: (currentYear, currentMonthValue),
            amounts: testCase.currentMonthIncomes
        )

        let expense = manager.calculateExpense(
            balances: balances,
            incomes: incomes,
            year: currentYear,
            month: currentMonthValue
        )

        if expense != testCase.expectedExpense {
            Issue.record("Expected \(testCase.expectedExpense) but got \(expense) for \(testCase.description)")
        }
    }

    @Test
    func testCalculateExpenseYearTransition() {
        let balances = [
            Balance(id: "1", account: "現金", year: 2024, month: 12, amount: 100000),
            Balance(id: "2", account: "現金", year: 2025, month: 1, amount: 80000)
        ]

        let incomes = [
            Income(id: "1", source: "給料", year: 2025, month: 1, amount: 150000)
        ]

        let expense = manager.calculateExpense(balances: balances, incomes: incomes, year: 2025, month: 1)

        if expense != 170000 {
            Issue.record("Expected 170000 but got \(expense)")
        }
    }

    @Test
    func testCalculateExpenseFiltersCorrectly() {
        let balances = [
            Balance(id: "1", account: "現金", year: 2025, month: 2, amount: 50000),
            Balance(id: "2", account: "現金", year: 2025, month: 3, amount: 100000),
            Balance(id: "3", account: "現金", year: 2025, month: 4, amount: 150000),
            Balance(id: "4", account: "現金", year: 2024, month: 3, amount: 999999)
        ]

        let incomes = [
            Income(id: "1", source: "給料", year: 2025, month: 3, amount: 200000),
            Income(id: "2", source: "給料", year: 2025, month: 4, amount: 300000),
            Income(id: "3", source: "給料", year: 2024, month: 3, amount: 999999)
        ]

        let expense = manager.calculateExpense(balances: balances, incomes: incomes, year: 2025, month: 3)

        if expense != 150000 {
            Issue.record("Expected 150000 but got \(expense)")
        }
    }
}
