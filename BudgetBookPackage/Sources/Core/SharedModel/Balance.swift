import Foundation

public struct Balance: Sendable, Equatable, Hashable {
    public var id: String
    public var account: String
    public var year: Int
    public var month: Int
    public var amount: Int
    
    public init(account: String, year: Int, month: Int, amount: Int) {
        self.id = UUID().uuidString
        self.account = account
        self.year = year
        self.month = month
        self.amount = amount
    }

    public init(id: String, account: String, year: Int, month: Int, amount: Int) {
        self.id = id
        self.account = account
        self.year = year
        self.month = month
        self.amount = amount
    }
    
    public init(dto: BalanceDTO) {
        self.id = dto.id
        self.account = dto.account
        self.year = dto.year
        self.month = dto.month
        self.amount = dto.amount
    }
    
    public func yearMonth() -> String {
        "\(month)-\(year)"
    }

    public func displayMonth() -> String {
        let monthStr = String(format: "%02d", month)
        let yearStr = String(format: "%02d", year % 100)
        return "\(yearStr)/\(monthStr)"
    }
}

public extension Array<Balance> {
    func convertToGraphData() -> [BalanceGraphModel] {
        var seen: [String] = []
        var result: [BalanceGraphModel] = []
        for item in self {
            let key = item.displayMonth()
            guard !seen.contains(key) else { continue }
            seen.append(key)
            let amount = self.filter { $0.displayMonth() == key }.reduce(0) { $0 + $1.amount }
            result.append(BalanceGraphModel(id: item.id, yearMonth: key, amount: amount))
        }
        return result.sortByMonth()
    }
    
    func latestBalance() -> Int {
        // 先月ぶん
        var latestYear = 0
        var latestMonth = 0

        let calendar = Calendar.current
        let now = Date()
        if let latestMonthDate = calendar.date(byAdding: .month, value: -1, to: now) {
            latestYear = calendar.component(.year, from: latestMonthDate)
            latestMonth = calendar.component(.month, from: latestMonthDate)
        }
        return self
            .filter { $0.year == latestYear && $0.month == latestMonth }
            .reduce(0) { $0 + $1.amount }
    }
}
