//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Runtime
import SwiftUIX

@MainActor
public final class LTAccountStore: ObservableObject {
    @FileStorage(
        directory: .documents,
        path: "Lite/Accounts",
        filename: UUID.self,
        coder: HadeanTopLevelCoder(coder: JSONCoder()),
        options: .init(readErrorRecoveryStrategy: .discardAndReset)
    )
    public var accounts: IdentifierIndexingArrayOf<LTAccount>
    
    private(set) lazy var allKnownAccountTypeDescriptions = {
        IdentifierIndexingArray<any LTAccountTypeDescription, LTAccountTypeIdentifier>(
            try! _SwiftRuntime.index
                .fetch(
                    .conformsTo(LTAccountTypeDescription.self),
                    .nonAppleFramework
                )
                .filter({ $0 is any _StaticInstance.Type })
                ._initializeAll(),
            id: \.accountType
        )
        .sorted(by: { $0.title < $1.title })
    }()
    
    public init() {

    }
    
    public subscript(
        _ type: LTAccountTypeIdentifier
    ) -> LTAccountTypeDescription {
        get {
            allKnownAccountTypeDescriptions[id: type]!
        }
    }
}

extension Array where Element == Any.Type {
    public func _initializeAll<T>(as type: T.Type = T.self) throws -> [T] {
        try map { element in
            if let element = element as? Initiable.Type {
                return try cast(element.init())
            } else {
                return try _generatePlaceholder(ofType: element, as: T.self)
            }
        }
    }
}
