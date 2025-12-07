//  Order.swift
//  GuacChain
//  Created by John Gallaugher on 12/8/25.
//  YouTube.com/profgallaugher - gallaugher.bsky.social

import Foundation
import SwiftData

@MainActor
@Model
class Order {
    var title: String
    var tacoQty: Int
    var burritoQty: Int
    var chipsQty: Int
    var horchataQty: Int
    var currencySelection: Currency
    var orderedOn = Date()
    
    init(title: String, tacoQty: Int, burritoQty: Int, chipsQty: Int, horchataQty: Int, currencySelection: Currency, orderedOn: Date = Date()) {
        self.title = title
        self.tacoQty = tacoQty
        self.burritoQty = burritoQty
        self.chipsQty = chipsQty
        self.horchataQty = horchataQty
        self.currencySelection = currencySelection
        self.orderedOn = orderedOn
    }
    
    convenience init() {
        self.init(title: "", tacoQty: 0, burritoQty: 0, chipsQty: 0, horchataQty: 0, currencySelection: .usd)
    }
}

extension Order {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(for: Order.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        // Create the actual MockData & insert it into container:
        container.mainContext.insert(Order(title: "Lunch Order", tacoQty: 3, burritoQty: 0, chipsQty: 0, horchataQty: 1, currencySelection: Currency.usd, orderedOn: Date()))
        container.mainContext.insert(Order(title: "Date Night Order", tacoQty: 3, burritoQty: 1, chipsQty: 1, horchataQty: 2, currencySelection: Currency.usd, orderedOn: Date()))
        container.mainContext.insert(Order(title: "Vacation in UK Order", tacoQty: 0, burritoQty: 1, chipsQty: 1, horchataQty: 1, currencySelection: Currency.gbp, orderedOn: Date()))
        container.mainContext.insert(Order(title: "Dinner Order", tacoQty: 1, burritoQty: 1, chipsQty: 1, horchataQty: 1, currencySelection: Currency.usd, orderedOn: Date()))
        container.mainContext.insert(Order(title: "Late Night Snack", tacoQty: 1, burritoQty: 0, chipsQty: 0, horchataQty: 0, currencySelection: Currency.usd, orderedOn: Date()))
        
        return container
    }
}
