import ComposableArchitecture
import Foundation
import SwiftData

public extension DependencyValues {
    var sourceRepository: SourceRepository {
        get { self[SourceRepository.self] }
        set { self[SourceRepository.self] = newValue }
    }
}

public struct SourceRepository: Sendable {
    public var fetchAll: @Sendable @DataActor () throws -> [Source]
    public var add: @Sendable @DataActor (String) throws -> Void
    public var delete: @Sendable @DataActor (Source) throws -> Void
    
    public init(database: Database) {
        self.fetchAll = {
            let context = try database.context()
            let descriptor = FetchDescriptor<SourceDTO>(sortBy: [
                .init(\.createdAt)
            ])
            let responce = try context.fetch(descriptor)
            return responce.map { Source(dto: $0) }
        }

        self.add = { name in
            let context = try database.context()
            context.insert(SourceDTO(name: name))
            try context.save()
        }
        
        self.delete = { source in
            let context = try database.context()
            let sourceID = source.id
            let predicate = #Predicate<SourceDTO> { dto in
                dto.id == sourceID
            }
            let descriptor = FetchDescriptor<SourceDTO>(predicate: predicate)
            if let dto = try context.fetch(descriptor).first {
                context.delete(dto)
                try context.save()
            }
        }
    }
}

extension SourceRepository: DependencyKey {
    public static let liveValue = Self(database: .liveValue)
}
