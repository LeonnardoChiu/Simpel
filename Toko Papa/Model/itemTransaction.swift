//
//  itemTransaction.swift
//  Toko Papa
//
//  Created by Leonnardo Benjamin Hutama on 12/12/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation
import CloudKit

class itemTransaction{
    var Id: CKRecord.ID
    var inventoryID: String
    var qty: Int
    
    init(id: CKRecord.ID, inventoryid: String, qty: Int) {
        self.Id = id
        self.inventoryID = inventoryid
        self.qty = qty
    }
}
