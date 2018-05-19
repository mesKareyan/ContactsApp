//
//  UserDetailsViewModel.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

class UserDetailsViewModel {
    
    var user: User!
    
    init() {
    }
    
    init(with user:User) {
        self.user = user
    }
    
    func saveUserData() {
        guard let user = user else { return }
        Network.createContanct(for: user) { (result) in
            print("User created")
            print(result)
        }
    }
    
}
