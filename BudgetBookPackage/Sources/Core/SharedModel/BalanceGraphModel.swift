/// @Parameter
/// id: String
/// yearMonth: String
/// amount: Int
public struct BalanceGraphModel: Identifiable, Equatable, Sendable {
    public var id: String
    public var yearMonth: String
    public var amount: Int
    
    public init(id: String, yearMonth: String, amount: Int) {
        self.id = id
        self.yearMonth = yearMonth
        self.amount = amount
    }
    
    public init(_ balance: Balance) {
        self.id = balance.id
        self.yearMonth = balance.displayMonth()
        self.amount = balance.amount
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

public extension Array<BalanceGraphModel> {
    func sortByMonth() -> [BalanceGraphModel] {
        self.sorted { (lhs: BalanceGraphModel, rhs: BalanceGraphModel) -> Bool in
            if lhs.year() == rhs.year() {
                return lhs.month() < rhs.month()
            }
            return lhs.year() < rhs.year()
        }
    }
    
    func rangeAmount() -> ClosedRange<Int> {
        let maxValue = (self.map { $0.amount }.max() ?? 0) + 10000
        return 0...maxValue
    }
}
