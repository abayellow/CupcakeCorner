//
//  Order.swift
//  CupcakeCorner
//
//  Created by Alexander Abanshin on 01.08.2025.
//

import Foundation
import Observation

@Observable
class Order: Codable {
    enum CodingKeys: String, CodingKey {
        case _type = "type"
        case _quantity = "quantity"
        case _specialRequestEnabled = "specialRequestEnabled"
        case _extraFrosting = "extraFrosting"
        case _addSprinkles = "addSprinkles"
        case _name = "name"
        case _city = "city"
        case _streetAddress = "streetAddress"
        case _zip = "zip"
    }
    
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]

    var type = 0
    var quantity = 3

    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    var address = Address()
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespaces).isEmpty || streetAddress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        }
        return true
    }
    
    var cost: Decimal {
        // $2 per cake
        var cost = Decimal(quantity) * 2

        // complicated cakes cost more
        cost += Decimal(type) / 2

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Decimal(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }

        return cost
    }
    
    required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         type = try container.decode(Int.self, forKey: ._type)
         quantity = try container.decode(Int.self, forKey: ._quantity)
         specialRequestEnabled = try container.decode(Bool.self, forKey: ._specialRequestEnabled)
         extraFrosting = try container.decode(Bool.self, forKey: ._extraFrosting)
         addSprinkles = try container.decode(Bool.self, forKey: ._addSprinkles)
         name = try container.decode(String.self, forKey: ._name)
         address = try container.decode(Address.self, forKey: ._streetAddress)
     }

     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(type, forKey: ._type)
         try container.encode(quantity, forKey: ._quantity)
         try container.encode(specialRequestEnabled, forKey: ._specialRequestEnabled)
         try container.encode(extraFrosting, forKey: ._extraFrosting)
         try container.encode(addSprinkles, forKey: ._addSprinkles)
         try container.encode(name, forKey: ._name)
         try container.encode(address, forKey: ._streetAddress)
     }
    
    init() {}
}
