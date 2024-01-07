//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Merge
import SwiftUIX

@MainActor
public final class LMServices: ObservableObject {
    @PublishedObject var accounts: LTAccountStore
    
    public init() {
        self.accounts = LTDataStore.shared.accounts
    }
}
