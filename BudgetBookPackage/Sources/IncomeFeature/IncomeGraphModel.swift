import SharedModel

/// @Parameter
/// id: String
/// yearMonth: String
/// amount: Int
public struct IncomeGraphModel: Identifiable, Equatable {
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
