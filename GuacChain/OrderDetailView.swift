//  ContentView.swift
//  GuacChain
//  Created by John Gallaugher on 12/7/25.
//  YouTube.com/profgallaugher - gallaugher.bsky.social

import SwiftUI
import SwiftData

struct OrderDetailView: View {
    @State var order: Order
    @State private var currencyVM = CurrencyViewModel()
    @State private var tacoQty = 0
    @State private var burritoQty = 0
    @State private var chipsQty = 0
    @State private var horchataQty = 0
    @State private var selectedCurrency = Currency.usd
    @State private var orderTitle = ""
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        VStack {
            HStack {
                Text("Guac")
                    .foregroundStyle(.green)
                Text("Chain")
                    .foregroundStyle(.red)
            }
            .font(Font.custom("Marker Felt", size: 48))
            .bold()
            
            Text("The World's Tastiest Tacos - But We Only Accept Crypto")
                .font(Font.custom("Papyrus", size: 20))
                .multilineTextAlignment(.center)
            
            Text("🌮")
                .font(Font.system(size: 80))
            
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Text("\(tacoQty)")
                        .font(Font.system(size: 48))
                        .fontWeight(.heavy)
                        .frame(width: 70)
                    VStack(alignment: .leading) {
                        Text("The Satoshi 'Taco' moto")
                            .font(.title2)
                        Stepper("", value: $tacoQty, in: 0...9)
                            .labelsHidden()
                    }
                }
                HStack(alignment: .top) {
                    Text("\(burritoQty)")
                        .font(Font.system(size: 48))
                        .fontWeight(.heavy)
                        .frame(width: 70)
                    VStack(alignment: .leading) {
                        Text("Bitcoin Burrito")
                            .font(.title2)
                        Stepper("", value: $burritoQty, in: 0...9)
                            .labelsHidden()
                    }
                }
                HStack(alignment: .top) {
                    Text("\(chipsQty)")
                        .font(Font.system(size: 48))
                        .fontWeight(.heavy)
                        .frame(width: 70)
                    VStack(alignment: .leading) {
                        Text("CryptoChips")
                            .font(.title2)
                        Stepper("", value: $chipsQty, in: 0...9)
                            .labelsHidden()
                    }
                }
                HStack(alignment: .top) {
                    Text("\(horchataQty)")
                        .font(Font.system(size: 48))
                        .fontWeight(.heavy)
                        .frame(width: 70)
                    VStack(alignment: .leading) {
                        Text("'No Bubble' Horchata")
                            .font(.title2)
                        Stepper("", value: $horchataQty, in: 0...9)
                            .labelsHidden()
                    }
                }
            }
            
            Spacer()
            
            Picker("", selection: $selectedCurrency) {
                ForEach(Currency.allCases, id: \.self) { currency in
                    Text(currency.rawValue)
                }
            }
            .pickerStyle(.segmented)
            
            HStack (alignment: .top){
                Text("Total:")
                    .font(.title)
                VStack(alignment: .leading) {
                    // The extra check to make sure we have a non-zero BTC isn't vital, but it can help prevent preview quirks
                    Text("฿ \(currencyVM.usdPerBTC > 0 ? calcTotal() / currencyVM.usdPerBTC : 0)")
                    Text("\(selectedCurrency.symbol()) \(calcBillInCurrency().formatted(.number.precision(.fractionLength(2))))")
                }
            }
            
            HStack {
                Text("Order Title:")
                    .bold()
                TextField("name this order", text: $orderTitle)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray, lineWidth: 1)
                    }
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("cancel", systemImage: "xmark") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("save", systemImage: "checkmark") {
                    order.title = orderTitle
                    order.tacoQty = tacoQty
                    order.burritoQty = burritoQty
                    order.chipsQty = chipsQty
                    order.horchataQty = horchataQty
                    order.currencySelection = selectedCurrency
                    modelContext.insert(order)
                    guard let _ = try? modelContext.save() else {
                        print("😡 ERROR: Save on DetailView did not work.")
                        return
                    }
                    dismiss()
                }
            }
        }
        .task {
            await currencyVM.getData()
        }
        .onAppear {
            orderTitle = order.title
            tacoQty = order.tacoQty
            burritoQty = order.burritoQty
            chipsQty = order.chipsQty
            horchataQty = order.horchataQty
            selectedCurrency = order.currencySelection
        }
    }
    
    func calcTotal() -> Double {
        let tacoTotal = Double(tacoQty) * Price.taco.rawValue
        let burritoTotal = Double(burritoQty) * Price.burrito.rawValue
        let chipsTotal = Double(chipsQty) * Price.chips.rawValue
        let horchataTotal = Double(horchataQty) * Price.horchata.rawValue
        
        return tacoTotal + burritoTotal + chipsTotal + horchataTotal
    }
    
    func calcBillInCurrency() -> Double {
        // Not required but this guard statement will make sure you don't divide by zero.
        guard currencyVM.usdPerBTC > 0 else {
            return calcTotal()   // fall back to USD price until we know rates
        }
        
        switch selectedCurrency {
        case .usd:
            return calcTotal()
        case .gbp:
            return calcTotal() / (currencyVM.usdPerBTC / currencyVM.gbpPerBTC)
        case .eur:
            return calcTotal() / (currencyVM.usdPerBTC / currencyVM.eurPerBTC)
        }
    }
}

#Preview {
    NavigationStack {
        OrderDetailView(order: Order(title: "Post Work-Out Order!", tacoQty: 2, burritoQty: 1, chipsQty: 1, horchataQty: 1, currencySelection: .usd))
            .modelContainer(for: Order.self, inMemory: true)
    }
}
