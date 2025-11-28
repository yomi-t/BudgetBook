/// @Parameter
/// id: String
/// yearMonth: String
/// amount: Int
public struct IncomeGraphModel: Identifiable, Equatable, Sendable {
    public var id: String
    public var yearMonth: String
    public var amount: Int
    
    public init(id: String, yearMonth: String, amount: Int) {
        self.id = id
        self.yearMonth = yearMonth
        self.amount = amount
    }
    
    public init(_ income: Income) {
        self.id = income.id
        self.yearMonth = income.displayMonth()
        self.amount = income.amount
    }
    
    public func year() -> Int {
        let year = self.yearMonth.components(separatedBy: "-").last ?? "0"
        return Int(year) ?? 0
    }
    
    public func month() -> Int {
        let month = self.yearMonth.components(separatedBy: "-").first ?? "0"
        return Int(month) ?? 0
    }
}

public extension Array<IncomeGraphModel> {
    func sortByMonth() -> [IncomeGraphModel] {
        self.sorted { (lhs: IncomeGraphModel, rhs: IncomeGraphModel) -> Bool in
            if lhs.year() == rhs.year() {
                return lhs.month() < rhs.month()
            }
            return lhs.year() < rhs.year()
        }
    }
    
    func rangeAmount() -> ClosedRange<Int> {
        let minValue = Swift.max((self.map { $0.amount }.min() ?? 0) - 10000, 0)
        let maxValue = (self.map { $0.amount }.max() ?? 0) + 10000
        return minValue...maxValue
    }
}
