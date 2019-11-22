//
//  Item.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 14/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import UIKit
import CloudKit

class Item {
    
    var itemImage: UIImage?
    var namaProduk: String
    var price: Int
    var qty: Int
    
    init(itemImage: UIImage, namaProduk: String, price: Int, qty: Int) {
        self.itemImage = itemImage
        self.namaProduk = namaProduk
        self.price = price
        self.qty = qty
    }
}
