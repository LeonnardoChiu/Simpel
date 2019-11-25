//
//  People.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 06/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation

class People {
    var username: String
    var password: String
    var firstName: String
    var lastName: String
    var phone: String
    
    init(username: String, password: String, firstName: String, lastName: String, phone: String) {
        self.username = username
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}
