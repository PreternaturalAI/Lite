//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Merge
import SwiftUIX

@MainActor
@Singleton
public final class LTDataStore: ObservableObject {
    @PublishedObject private var _accounts = LTAccountStore()
    
    public var accounts: LTAccountStore {
        _accounts
    }
}
