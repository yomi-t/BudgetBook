import Core
import Foundation
import Testing

private struct ExpenseManagerLatestTests {
    let manager = ExpenseManager()

    struct LatestExpenseTestCase: Sendable {
        let balances: [Balance]
        let incomes: [Income]
    }

    @Test(arguments: [
        LatestExpenseTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 50000),
                Balance(account: "現金", year: 2025, month: 2, amount: 45000)
            ],
            incomes: [
                Income(source: "給料", year: 2025, month: 2, amount: 200000)
            ]
        ),
        LatestExpenseTestCase(
            balances: [],
            incomes: []
        ),
        LatestExpenseTestCase(
            balances: [
                Balance(account: "現金", year: 2025, month: 1, amount: 100000)
            ],
            incomes: [
                Income(source: "給料", year: 2025, month: 1, amount: 150000)
            ]
        )
    ])
    func testLatestExpense(_ testCase: LatestExpenseTestCase) {
        let calendar = Calendar.current
        let now = Date()

        guard let lastMonth = calendar.date(byAdding: .month, value: -1, to: now) else {
            Issue.record("Failed to calculate last month")
            return
        }

        // テストデータの年月を現在の日付に合わせて調整
        let adjustedBalances = testCase.balances.map { balance in
            let monthOffset = (balance.year - 2025) * 12 + balance.month
            guard let targetDate = calendar.date(byAdding: .month, value: monthOffset - 1, to: now) else {
                return balance
            }
            return Balance(
                id: balance.id,
                account: balance.account,
                year: calendar.component(.year, from: targetDate),
                month: calendar.component(.month, from: targetDate),
                amount: balance.amount
            )
        }

        let adjustedIncomes = testCase.incomes.map { income in
            let monthOffset = (income.year - 2025) * 12 + income.month
            guard let targetDate = calendar.date(byAdding: .month, value: monthOffset - 1, to: now) else {
                return income
            }
            return Income(
                id: income.id,
                source: income.source,
                year: calendar.component(.year, from: targetDate),
                month: calendar.component(.month, from: targetDate),
                amount: income.amount
            )
        }

        let expense = manager.latestExpense(balances: adjustedBalances, incomes: adjustedIncomes)

        // 結果が0以上であることを確認
        if expense < 0 {
            Issue.record("Latest expense should not be negative: \(expense)")
        }
    }
}
