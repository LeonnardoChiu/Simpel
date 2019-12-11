//
//  TransactionSummary.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 11/12/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation

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
