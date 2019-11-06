//
//  People.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 06/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation

class People {
    var firstName: String
    var lastName: String
    var store: String
    var role: String
    var email: String
    var phone: String
    
    init(firstName: String, lastName: String, store: String, role: String, email: String, phone: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.store = store
        self.role = role
        self.email = email
        self.phone = phone
    }
}
