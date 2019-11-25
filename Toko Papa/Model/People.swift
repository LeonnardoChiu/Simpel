//
//  People.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 06/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation
import CloudKit
class People {
    var username: String
    var password: String
    var firstName: String
    var lastName: String
    var phone: String
    var Id: CKRecord.ID
    
    init(id: CKRecord.ID, username: String, password: String, firstName: String, lastName: String, phone: String) {
        self.Id = id
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}
