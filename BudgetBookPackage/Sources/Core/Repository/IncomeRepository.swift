import ComposableArchitecture
import Foundation
import SwiftData

public extension DependencyValues {
    var incomeRepository: IncomeRepository {
        get { self[IncomeRepository.self] }
        set { self[IncomeRepository.self] = newValue }
    }
}

public struct IncomeRepository: Sendable {
    public var fetchAll: @Sendable @DataActor () throws -> [Income]
    public var fetchMonth: @Sendable @DataActor (Int, Int) throws -> [Income]
    public var add: @Sendable @DataActor (Income) throws -> Void
    public var delete: @Sendable @DataActor (Income) throws -> Void

    enum IncomeError: Error {
        case add
        case delete
        case save
    }

    public init(database: Database) {
        self.fetchAll = {
            let context = try database.context()
            let descriptor = FetchDescriptor<IncomeDTO>(sortBy: [
                .init(\.year),
                .init(\.month)
            ])
            let response = try context.fetch(descriptor)
            return response.map { Income(dto: $0) }
        }
        
        self.fetchMonth = { year, month in
            let context = try database.context()
            let predicate = #Predicate<IncomeDTO> { dto in
                dto.year == year && dto.month == month
            }
            let descriptor = FetchDescriptor<IncomeDTO>(predicate: predicate)
            let response = try context.fetch(descriptor)
            return response.map { Income(dto: $0) }
        }

        self.add = { model in
            let context = try database.context()
            context.insert(IncomeDTO(model))
            try context.save()
        }

        self.delete = { model in
            let context = try database.context()
            let modelId = model.id
            let predicate = #Predicate<IncomeDTO> { dto in
                dto.id == modelId
            }
            let descriptor = FetchDescriptor<IncomeDTO>(predicate: predicate)
            if let dto = try context.fetch(descriptor).first {
                context.delete(dto)
                try context.save()
            }
            print("Income deleted: \(model)")
        }
    }
}

extension IncomeRepository: DependencyKey {
    public static let liveValue = Self(database: .liveValue)
}
