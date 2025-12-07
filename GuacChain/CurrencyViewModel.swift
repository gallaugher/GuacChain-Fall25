//  CurrencyViewModel.swift
//  GuacChain
//  Created by John Gallaugher on 12/7/25.
//  YouTube.com/profgallaugher - gallaugher.bsky.social

import Foundation

@MainActor
@Observable

class CurrencyViewModel  {
    
    struct Returned: Codable {
        var bitcoin: BitCoin
    }
    
    struct BitCoin: Codable {
        var usd: Double
        var gbp: Double
        var eur: Double
    }
    
    var urlString = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd,gbp,eur"
    var usdPerBTC = 0.0
    var gbpPerBTC = 0.0
    var eurPerBTC = 0.0

    func getData() async {
        print("🕸️ We are accessing the url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a url from \(urlString)")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else {
                print("😡 JSON ERROR: Could not decode JSON from \(urlString)")
                return
            }
            self.usdPerBTC = returned.bitcoin.usd
            self.gbpPerBTC = returned.bitcoin.gbp
            self.eurPerBTC = returned.bitcoin.eur
            print("One Bitcoin is currently worth:  \(self.usdPerBTC) usd, \(self.gbpPerBTC) gbp, and \(self.eurPerBTC) eur")
        } catch {
            print("😡 ERROR: Could not get data from \(urlString)")
        }
    }
}
