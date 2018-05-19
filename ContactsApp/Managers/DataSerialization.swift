//
//  DataSerialization.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

class APIDataSerializer {
    
    static func users(from data: Data) -> [User] {
        let decoder = JSONDecoder()
        do {
            let users = try decoder.decode([User].self, from: data)
            return users
        } catch {
            print(error)
            return []
        }
    }
    
    static func user(from data: Data) -> User? {
        let decoder = JSONDecoder()
        do {
            let users = try decoder.decode(User.self, from: data)
            return users
        } catch {
            print(error)
            return nil
        }
    }
    
}
