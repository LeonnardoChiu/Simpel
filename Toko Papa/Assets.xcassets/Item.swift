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
    
    //var imageItem: UIImage?
    var namaProduk: String
    var price: Int
    var qty: Int
    
    init(namaProduk: String, price: Int, qty: Int) {
        self.namaProduk = namaProduk
        self.price = price
        self.qty = qty
    }
    
}

class Items: NSObject, NSCoding {
    
    // MARK: - Types
    
    private enum CoderKeys: String {
        case namaProdukKey
        case qtyKey
        case priceKey
    }
    
    struct ProductList {
        static let Indomie = "Indomie"
        static let Samsung = "Samsung"
        static let Apple = "Apple"
        static let Jacket = "Jacket"
        static let Micin = "Micin"
        static let Kaos = "Kaos"
        static let Celana = "Celana"
        static let Topi = "Topi"
    }
    
    // MARK: - Properties
    @objc let namaProduk: String
    @objc let price: Int
    @objc let qty: Int
        
    // MARK: - Initializers
    init(namaProduk: String, price: Int, qty: Int) {
        self.namaProduk = namaProduk
        self.price = price
        self.qty = qty
    }
    
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        guard let decodedNamaProduk = aDecoder.decodeObject(forKey: CoderKeys.namaProdukKey.rawValue) as? String else {
            fatalError("Gak ada produknya bos")
        }
        
        namaProduk = decodedNamaProduk
        price = aDecoder.decodeInteger(forKey: CoderKeys.priceKey.rawValue)
        qty = aDecoder.decodeInteger(forKey: CoderKeys.qtyKey.rawValue)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(namaProduk, forKey: CoderKeys.namaProdukKey.rawValue)
        aCoder.encode(price, forKey: CoderKeys.priceKey.rawValue)
        aCoder.encode(qty, forKey: CoderKeys.qtyKey.rawValue)

    }
    
}
