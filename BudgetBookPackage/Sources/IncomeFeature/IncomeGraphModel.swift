import SharedModel

public struct IncomeGraphModel: Identifiable, Equatable {
    public var id: String
    public var yearMonth: String
    public var amount: Int
    
    public init(id: String, yearMonth: String, amount: Int) {
        self.id = id
        self.yearMonth = yearMonth
        self.amount = amount
    }
    
    public func formatGraphData(incomes: [Income]) -> [IncomeGraphModel] {
        incomes.map {
            IncomeGraphModel(id: $0.id, yearMonth: $0.yearMonth(), amount: $0.amount)
        }
    }
}
