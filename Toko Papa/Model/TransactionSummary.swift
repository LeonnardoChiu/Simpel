//
//  TransactionSummary.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 11/12/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation
import CloudKit

struct TransactionSummary {
    var transactions: [Transaksi] {
        didSet {
            for x in self.transactions {
                for i in x.items{
                    
//                    let dict = ["\(i.item.namaItem)" : i.unitSold]
//                    itemSummaries.append(dict)
                    
                    if itemSummaries["\(i.item.namaItem)"] == nil{
                        itemSummaries["\(i.item.namaItem)"] = i.unitSold
                    }else {
                        itemSummaries["\(i.item.namaItem)"] = itemSummaries["\(i.item.namaItem)"]! + i.unitSold
                    }
                    
                    
                }
                
            }
        }
    }
    var itemSummaries: [String : Int]!
}


class SummaryTransaction {
    var id: CKRecord.ID
    var tanggal: Int
    var bulan: Int
    var tahun: Int
    var itemID: [String]
    var tokoID: String
    var metodePembayaran: String
    var totalPenjualan: Int
    
    init(id: CKRecord.ID, tokoID: String, itemID: [String], tanggal: Int, bulan: Int, tahun: Int, metodePembayaran: String, totalPenjualan: Int) {
        self.id = id
        self.tokoID = tokoID
        self.itemID = itemID
        self.tanggal = tanggal
        self.bulan = bulan
        self.tahun = tahun
        self.metodePembayaran = metodePembayaran
        self.totalPenjualan = totalPenjualan
    }
    
    
}
