//  OrderListView.swift
//  GuacChain
//  Created by John Gallaugher on 12/8/25.
//  YouTube.com/profgallaugher - gallaugher.bsky.social

import SwiftUI
import SwiftData

struct OrderListView: View {
    @Query var orders: [Order]
    @State private var sheetIsPresented = false
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack {
            List(orders) { order in
                NavigationLink {
                    OrderDetailView(order: order)
                } label: {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(order.title)
                            Spacer()
                            Text(order.orderedOn.formatted(date: .numeric, time: .omitted))
                        }
                        Text(returnQtyLine(order: order))
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                    }
                    .font(.title2)
                }
                .swipeActions {
                    Button("", systemImage: "trash", role: .destructive) {
                        modelContext.delete(order)
                        guard let _ = try? modelContext.save() else {
                            print("😡 ERROR: Save after .delete did not work.")
                            return
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Past Orders:")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("add", systemImage: "plus") {
                        sheetIsPresented.toggle()
                    }
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack {
                OrderDetailView(order: Order())
            }
        }
        
    }
    
    func returnQtyLine(order: Order) -> String {
        var orderArray: [String] = []
        if order.tacoQty != 0 { orderArray.append("Taco: \(order.tacoQty)") }
        if order.burritoQty != 0 { orderArray.append("Burrito: \(order.burritoQty)") }
        if order.chipsQty != 0 { orderArray.append("Chips: \(order.chipsQty)") }
        if order.horchataQty != 0 { orderArray.append("Horchata: \(order.horchataQty)") }
        return orderArray.joined(separator: ", ")
    }
}

#Preview {
    OrderListView()
        .modelContainer(Order.preview)
}
