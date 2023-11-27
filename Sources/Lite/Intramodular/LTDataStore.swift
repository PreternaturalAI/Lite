//
// Copyright (c) Vatsal Manot
//

import CorePersistence
import Merge
import SwiftUIX

@MainActor
@Singleton
public final class LTDataStore: ObservableObject {
    @PublishedObject var accounts = LTAccountsStore()
}
