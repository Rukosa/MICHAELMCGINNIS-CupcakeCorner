//
//  AddressView.swift
//  MICHAELMCGINNIS-CupcakeCorner
//
//  Created by Michael Mcginnis on 3/23/22.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    var body: some View {
        Form{
            Section{
                TextField("Name", text: $order.orderItem.name)
                TextField("Street Address", text: $order.orderItem.streetAddress)
                TextField("City", text: $order.orderItem.city)
                TextField("Zip", text: $order.orderItem.zip)
            }
            
            Section{
                NavigationLink{
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.orderItem.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
