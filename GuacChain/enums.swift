//  enums.swift
//  GuacChain
//  Created by John Gallaugher on 12/8/25.
//  YouTube.com/profgallaugher - gallaugher.bsky.social

import Foundation

enum Currency: String, CaseIterable, Codable {
    case usd = "$ USD"
    case gbp = "£ GBP"
    case eur = "€ EUR"
    
    func symbol() -> String {
        switch self {
        case .usd: return "$"
        case .gbp: return "£"
        case .eur: return "€"
        }
    }
}


enum Price: Double, CaseIterable {
    case taco = 5.00
    case burrito = 8.00
    case chips = 3.00
    case horchata = 2.00
}
