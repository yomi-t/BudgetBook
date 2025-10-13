import Protocols
import SharedModel
import SwiftData

@MainActor
public class BalanceRepository: BalanceRepositoryProtocol {

    private let modelContext: ModelContext

    public init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    public func add(_ balance: Balance) async {
        do {
            modelContext.insert(balance)
            try modelContext.save()
        } catch {
            print("Error saving balance: \(error)")
        }
    }

    public func fetchAllBalances() async -> [Balance] {
        let descriptor = FetchDescriptor<Balance>(sortBy: [
            .init(\.year),
            .init(\.month)
        ])
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching balances: \(error)")
            return []
        }
    }

    public func fetchLatestBalances() async -> [Balance] {
        let descriptor = FetchDescriptor<Balance>(sortBy: [
            .init(\.year, order: .reverse),
            .init(\.month, order: .reverse)
        ])
        do {
            let response = try modelContext.fetch(descriptor)
            return selectFirstBalance(response)
        } catch {
            print("Error fetching latest balances: \(error)")
            return []
        }
    }
}

extension BalanceRepository {
    private func selectFirstBalance(_ balances: [Balance]) -> [Balance] {
        var latestBalances: [Balance] = []
        for balance in balances {
            if latestBalances.contains(where: { $0.account == balance.account }) {
                continue
            } else {
                latestBalances.append(balance)
            }
        }

        return latestBalances
    }
}

