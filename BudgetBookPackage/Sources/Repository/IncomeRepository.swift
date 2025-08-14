import Protocols
import SharedModel
import SwiftData

@MainActor
public class IncomeRepository: IncomeRepositoryProtocol {
    private var container: ModelContainer?
    
    public static let shared = IncomeRepository()

    private init() {
        self.container = try? ModelContainer(for: Income.self)
    }

    public func add(_ income: Income) async {
        container?.mainContext.insert(income)
        try? container?.mainContext.save()
    }

    public func fetchAllIncomes() async -> [Income] {
        let descriptor = FetchDescriptor<Income>(sortBy: [
            .init(\.year),
            .init(\.month)
        ])
        do {
            return try container?.mainContext.fetch(descriptor) ?? []
        } catch {
            print("Error fetching incomes: \(error)")
            return []
        }
    }
}
