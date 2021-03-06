//
//  CheckoutView.swift
//  MICHAELMCGINNIS-CupcakeCorner
//
//  Created by Michael Mcginnis on 3/23/22.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingFail = false
    func placeOrder() async{
        guard let encoded = try? JSONEncoder().encode(order) else{
            print("Failed to encode order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("applications/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        do{
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.orderItem.quantity)x \(OrderStruct.types[decodedOrder.orderItem.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch{
            print("Checkout failed.")
            confirmationMessage = error.localizedDescription
            showingFail = true
        }
    }
    
    var body: some View {
        ScrollView{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) {image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                
                Text("Your total is \(order.orderItem.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order"){
                    Task{
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation){
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
        .alert("Order Failed!", isPresented: $showingFail){
            Button("OK") {}
        } message: {
            Text(confirmationMessage)
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
