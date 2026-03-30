import Foundation

public struct Income: Sendable, Equatable, Hashable {
    public var id: String
    public var source: String
    public var year: Int
    public var month: Int
    public var amount: Int
    
    public init(source: String, year: Int, month: Int, amount: Int) {
        self.id = UUID().uuidString
        self.source = source
        self.year = year
        self.month = month
        self.amount = amount
    }
    
    public init(id: String, source: String, year: Int, month: Int, amount: Int) {
        self.id = id
        self.source = source
        self.year = year
        self.month = month
        self.amount = amount
    }
    
    public init(dto: IncomeDTO) {
        self.id = dto.id
        self.source = dto.source
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

public extension Array<Income> {
    func convertToGraphData() -> [IncomeGraphModel] {
        var seen: [String] = []
        var result: [IncomeGraphModel] = []
        for item in self {
            let key = item.displayMonth()
            guard !seen.contains(key) else { continue }
            seen.append(key)
            let amount = self.filter { $0.displayMonth() == key }.reduce(0) { $0 + $1.amount }
            result.append(IncomeGraphModel(id: item.id, yearMonth: key, amount: amount))
        }
        return result.sortByMonth()
    }
    
    func latestIncome() -> Int {
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
    
    func thisYearIncome() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let currentYear = calendar.component(.year, from: now)
        return self
            .filter { $0.year == currentYear }
            .reduce(0) { $0 + $1.amount }
    }
    
    func leftMonthCount() -> Int {
        let calendar = Calendar.current
        let now = Date()
        let currentMonth = calendar.component(.month, from: now)
        let currentYear = calendar.component(.year, from: now)
        var left = 12 - currentMonth + 1
        if self.contains(where: { $0.year == currentYear && $0.month == currentMonth }) {
            left -= 1
        }
        if left <= 0 {
            return 1
        }
        return left
    }
}
