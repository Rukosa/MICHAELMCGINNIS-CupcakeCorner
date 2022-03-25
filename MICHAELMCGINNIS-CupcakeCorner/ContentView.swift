//
//  ContentView.swift
//  MICHAELMCGINNIS-CupcakeCorner
//
//  Created by Michael Mcginnis on 3/23/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var order = Order()
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Picker("Select your cake type", selection: $order.orderItem.type){
                        ForEach(OrderStruct.types.indices){
                            Text(OrderStruct.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(order.orderItem.quantity)", value: $order.orderItem.quantity, in: 3...20)
                }
                Section{
                    Toggle("Any special requests?", isOn: $order.orderItem.specialRequestEnabled.animation())
                    if order.orderItem.specialRequestEnabled{
                        Toggle("Add extra frosting", isOn: $order.orderItem.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.orderItem.addSprinkles)
                    }
                }
                Section{
                    NavigationLink{
                        AddressView(order: order)
                    } label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
