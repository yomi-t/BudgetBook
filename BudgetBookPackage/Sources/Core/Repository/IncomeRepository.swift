import SwiftData

@MainActor
public class IncomeRepository: IncomeRepositoryProtocol {
    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func add(_ income: Income) async {
        do {
            modelContext.insert(income)
            try modelContext.save()
        } catch {
            print("Error saving income: \(error)")
        }
        
    }

    public func fetchAllIncomes() async -> [Income] {
        let descriptor = FetchDescriptor<Income>(sortBy: [
            .init(\.year),
            .init(\.month)
        ])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching incomes: \(error)")
            return []
        }
    }
}
