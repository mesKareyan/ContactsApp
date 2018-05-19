//
//  User.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var _id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var email: String = ""
    var notes: String = ""
    var images: [String] = []
    
    var jsonDict: [String: Any] {
        return [
            "firstName": firstName,
            "lastName" : lastName,
            "phone": phone,
            "email": email,
            "notes": notes,
            "images": images
        ]
    }
    
}
