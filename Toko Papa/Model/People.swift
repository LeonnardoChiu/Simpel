//
//  People.swift
//  Toko Papa
//
//  Created by Ricky Erdiansyah on 06/11/19.
//  Copyright © 2019 Louis  Valen. All rights reserved.
//

import Foundation
import CloudKit
import AuthenticationServices

struct User {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
    }
    
    
}

class People {
    var firstName: String
    var lastName: String
    var phone: String
    var role: String
    var Id: CKRecord.ID
    var tokoID: String
    
    var email: String
    var appleID: String
    var image: UIImage?
    
    init(id: CKRecord.ID, appleid: String, email: String, firstName: String, lastName: String, phone: String, rolee: String, toko:String, profileImage: UIImage) {
        self.Id = id
        self.email = email
        self.appleID = appleid
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.role = rolee
        self.tokoID = toko
        self.image = profileImage
    }
    
    func prints(){
        print(Id)
        print(email)
        print(appleID)
        print(firstName)
        print(lastName)
        print(phone)
    }
}

extension User: CustomDebugStringConvertible {
    var debugDescription: String {
        return """
        ID: \(id)
        First Name: \(firstName)
        Last Name: \(lastName)
        Email: \(email)
        """
    }
    
    
}
