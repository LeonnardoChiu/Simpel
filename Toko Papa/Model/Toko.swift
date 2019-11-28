//
//  Toko.swift
//  Toko Papa
//
//  Created by Louis  Valen on 28/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation
import CloudKit

class Toko {
    var namaToko: String?
    var uniqcode: Int?
    var Id: CKRecord.ID
    
    init(id:CKRecord.ID, namatoko: String, uniq: Int) {
        self.Id = id
        self.namaToko = namatoko
        self.uniqcode = uniq
    }
}
