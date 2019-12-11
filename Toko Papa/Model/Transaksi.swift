//
//  Transaksi.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 11/12/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation
import CloudKit

enum MetodePembayaran: String {
    case tunai = "Tunai"
    case nonTunai = "Non tunai"
}

struct Transaksi {
    typealias ItemTransaction  = (unitSold: Int,item: Inventory)
    
    let tokoID: String
    let metodePembayaran: MetodePembayaran
    var items: [ItemTransaction]
    let transactionDate: (day: Int, month: Int, year: Int)
    
    /// return value berupa struck Transaksi
    static func fetchDummyData() -> Transaksi {
        let tas = Inventory(id: CKRecord.ID(recordName: "tas tas"), imageItem: #imageLiteral(resourceName: "Access"), namaItem: "Tas", barcode: "23131414", category: "Tas", distributor: "Sendiri", price: 1000, stock: 5, version: 1, unit: "aaa", toko: "Toko Papa")
        let tasTransaction: ItemTransaction = (5,tas)
        
        let baju = Inventory(id: CKRecord.ID(recordName: "baju baju"), imageItem: #imageLiteral(resourceName: "Access"), namaItem: "Baju", barcode: "23131414", category: "Baju", distributor: "Sendiri", price: 2000, stock: 56, version: 1, unit: "bbb", toko: "Toko Papa")
        let bajuTransaction: ItemTransaction = (3,baju)
        
        let celana = Inventory(id: CKRecord.ID(recordName: "celana celana"), imageItem: #imageLiteral(resourceName: "Access"), namaItem: "Celana", barcode: "23131414", category: "Celana", distributor: "Sendiri", price: 5000, stock: 51, version: 1, unit: "ccc", toko: "Toko Papa")
        let celanaTransaction: ItemTransaction = (2,celana)
        
        let jaket = Inventory(id: CKRecord.ID(recordName: "jaket jaket"), imageItem: #imageLiteral(resourceName: "Access"), namaItem: "Jaket", barcode: "23131414", category: "Jaket", distributor: "Sendiri", price: 15000, stock: 15, version: 1, unit: "ccc", toko: "Toko Papa")
        let jaketTransaction: ItemTransaction = (20,jaket)
        
        let dummyTransaction = Transaksi(tokoID: "", metodePembayaran: .tunai, items: [tasTransaction, bajuTransaction, celanaTransaction, jaketTransaction], transactionDate: (day: 5, month: 10, year: 2019))
        
        return dummyTransaction
    }
    
    
    
}
