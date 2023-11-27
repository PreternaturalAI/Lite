//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import SwiftUIX

@MainActor
public final class LTAccountsStore: ObservableObject {
    @FileStorage(
        directory: .documents,
        path: "Lite/Accounts",
        filename: UUID.self,
        coder: HadeanTopLevelCoder(coder: JSONCoder()),
        options: .init(readErrorRecoveryStrategy: .discardAndReset)
    )
    public var accounts: IdentifierIndexingArrayOf<LTAccount>
    
    @Published public var accountTypes = IdentifierIndexingArray<any LTAccountTypeDescription, LTAccountType>(id: \.accountType)
    
    public init() {
        accountTypes.append(_AllCasesOf<LTAccountTypeDescription>.OpenAI())
        accountTypes.append(_AllCasesOf<LTAccountTypeDescription>.Anthropic())
    }
    
    public subscript(_ type: LTAccountType) -> LTAccountTypeDescription {
        get {
            accountTypes[id: type]!
        }
    }
}
