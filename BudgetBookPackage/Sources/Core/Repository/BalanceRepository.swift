import ComposableArchitecture
import Foundation
import SwiftData

public extension DependencyValues {
    var balanceRepository: BalanceRepository {
        get { self[BalanceRepository.self] }
        set { self[BalanceRepository.self] = newValue }
    }
}

public struct BalanceRepository: Sendable {
    public var fetchAll: @Sendable @DataActor () throws -> [Balance]
    public var add: @Sendable @DataActor (Balance) throws -> Void
    public var delete: @Sendable @DataActor (Balance) throws -> Void

    enum BalanceError: Error {
        case add
        case delete
        case save
    }
    
    public init(database: Database) {
        self.fetchAll = {
            let context = try database.context()
            let descriptor = FetchDescriptor<BalanceDTO>(sortBy: [
                .init(\.year),
                .init(\.month)
            ])
            let responce = try context.fetch(descriptor)
            return responce.map { Balance(dto: $0) }
        }

        self.add = { model in
            let context = try database.context()
            context.insert(BalanceDTO(model))
            try context.save()
        }
        
        self.delete = { model in
            let context = try database.context()
            let modelId = model.id
            let predicate = #Predicate<BalanceDTO> { dto in
                dto.id == modelId
            }
            let descriptor = FetchDescriptor<BalanceDTO>(predicate: predicate)
            if let object = try context.fetch(descriptor).first {
                context.delete(object)
                try context.save()
            } else {
                throw BalanceError.delete
            }
        }
    }
}

extension BalanceRepository: DependencyKey {
    public static let liveValue = Self(database: .liveValue)
}
