import Foundation

public struct MonthlyExpenseResult: Sendable {
    public let year: Int
    public let month: Int
    public let displayMonth: String
    public let amount: Int
}

public class ExpenseManager {

    public init() {}

    public func calculateExpense(balances: [Balance], incomes: [Income], year: Int, month: Int) -> Int {
        let latestMoney = balances
            .filter { $0.year == year && $0.month == month }
            .reduce(0) { $0 + $1.amount }
        let latestIncome = incomes
            .filter { $0.year == year && $0.month == month }
            .reduce(0) { $0 + $1.amount }
        
        var lastYear = year
        var lastMonth = month
        if month == 1 {
            lastYear -= 1
            lastMonth = 12
        } else {
            lastMonth -= 1
        }
        let lastMoney = balances
            .filter { $0.year == lastYear && $0.month == lastMonth }
            .reduce(0) { $0 + $1.amount }
        
        if latestIncome - (latestMoney - lastMoney) < 0 {
            return 0
        } else {
            return latestIncome - (latestMoney - lastMoney)
        }
    }
    
    public func computeMonthlyExpenses(
        balances: [Balance],
        incomes: [Income]
    ) -> [MonthlyExpenseResult] {
        var seen: Set<String> = []
        var result: [MonthlyExpenseResult] = []
        for income in incomes {
            let key = "\(income.year)-\(income.month)"
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            let currentBalance = balances
                .filter { $0.year == income.year && $0.month == income.month }
                .reduce(0) { $0 + $1.amount }
            let incomeAmount = incomes
                .filter { $0.year == income.year && $0.month == income.month }
                .reduce(0) { $0 + $1.amount }
            let lastYear = income.month == 1 ? income.year - 1 : income.year
            let lastMonth = income.month == 1 ? 12 : income.month - 1
            let lastBalance = balances
                .filter { $0.year == lastYear && $0.month == lastMonth }
                .reduce(0) { $0 + $1.amount }
            let expense = max(0, incomeAmount - (currentBalance - lastBalance))
            result.append(MonthlyExpenseResult(
                year: income.year,
                month: income.month,
                displayMonth: income.displayMonth(),
                amount: expense
            ))
        }
        return result
    }

    public func latestExpense(balances: [Balance], incomes: [Income]) -> Int {
        // 先月ぶん
        var latestYear = 0
        var latestMonth = 0
        
        let calendar = Calendar.current
        let now = Date()
        if let latestMonthDate = calendar.date(byAdding: .month, value: -1, to: now) {
            latestYear = calendar.component(.year, from: latestMonthDate)
            latestMonth = calendar.component(.month, from: latestMonthDate)
        }
        
        return calculateExpense(balances: balances, incomes: incomes, year: latestYear, month: latestMonth)
    }
}
