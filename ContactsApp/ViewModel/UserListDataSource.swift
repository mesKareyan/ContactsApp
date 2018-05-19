//
//  UserListDataSource.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

class UsersListDataSource : NSObject, UITableViewDataSource {
    
    var users: [User]!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell",
                                                 for: indexPath) as! UserTableViewCell
        let userData = self.users[indexPath.row]
        cell.user = userData
        return cell
    }
    

}
