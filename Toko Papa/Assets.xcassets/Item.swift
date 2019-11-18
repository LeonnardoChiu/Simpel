//
//  Item.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 14/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation

struct Item {
    let name: String
    let category: Category
    
    enum Category: String {
        case All
        case Food
        case Tools
        case Misc
    
    }
    
    
    
}
