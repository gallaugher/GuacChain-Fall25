//  GuacChainApp.swift
//  GuacChain
//  Created by John Gallaugher on 12/7/25.
//  YouTube.com/profgallaugher - gallaugher.bsky.social

import SwiftUI
import SwiftData

@main
struct GuacChainApp: App {
    var body: some Scene {
        WindowGroup {
            OrderListView()
                .modelContainer(for: Order.self)
        }
    }
    
    // Will allow us to find where our simulator data is saved:
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
