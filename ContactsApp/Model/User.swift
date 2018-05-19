//
//  User.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let _id: String
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    let notes: String
    
    var jsonDict: [String: String] {
        return [
            "firstName": firstName,
            "lastName" : lastName,
            "phone": phone,
            "email": email,
            "notes" :notes
        ]
    }
    
}
