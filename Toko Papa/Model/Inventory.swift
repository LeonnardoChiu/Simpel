//
//  Inventory.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 21/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation
import UIKit
import CloudKit


class Inventory {
    /// variable
    var imageItem: UIImage?
    var namaItem: String
    var barcode: String
    var category: String
    var distributor: String
    var price: Int
    var stock: Int
    var version: Int
    var unit: String
    var Id: CKRecord.ID
    var tokoID: String
    
    /// inisialisasi
    init(id:CKRecord.ID, imageItem: UIImage, namaItem: String, barcode: String, category: String, distributor: String, price: Int, stock: Int, version: Int, unit: String, toko:String) {
        self.Id = id
        self.imageItem = imageItem
        self.namaItem = namaItem
        self.barcode = barcode
        self.category = category
        self.distributor = distributor
        self.price = price
        self.stock = stock
        self.version = version
        self.unit = unit
        self.tokoID = toko
    }
}
