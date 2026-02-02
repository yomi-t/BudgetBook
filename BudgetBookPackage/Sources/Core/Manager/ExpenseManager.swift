import Foundation

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
