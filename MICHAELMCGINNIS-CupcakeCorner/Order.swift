//
//  Order.swift
//  MICHAELMCGINNIS-CupcakeCorner
//
//  Created by Michael Mcginnis on 3/23/22.
//

import Foundation

enum CodingKeys: CodingKey{
    case type, quantity, extraFrosting, addSprinkles, name, streetAddress, city, zip
}
enum CodingKeys3 : CodingKey{
    case orderItem
}
//check project 7 chal 3?
struct OrderStruct: Codable, Hashable{
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false{
        didSet{
            if specialRequestEnabled == false{
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    //store delivery details
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool{
        if name.isEmpty || streetAddress.isEmpty{
            return false
        }
        if name.hasPrefix(" ") || name.hasSuffix(" ") || streetAddress.hasPrefix(" ") || streetAddress.hasSuffix(" ") {
            return false
        }
        return true
    }
    
    //cost handling
    var cost: Double{
        var cost = Double(quantity) * 2
        
        cost += (Double(type) / 2)
        
        if extraFrosting{
            cost += Double(quantity)
        }
        
        if addSprinkles{
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}

class Order: ObservableObject, Codable {
    @Published var orderItem = OrderStruct()
    
    //codable conformance
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys3.self)
        
        try container.encode(orderItem, forKey: .orderItem)
        }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys3.self)
        
        orderItem = try container.decode(OrderStruct.self, forKey: .orderItem)
    }
    
    init(){}
}
