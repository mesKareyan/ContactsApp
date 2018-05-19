//
//  ViewModel.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import Foundation

struct UsersViewModel {
    
    weak var dataSource : UsersListDataSource?
    
    init(dataSource : UsersListDataSource?) {
        self.dataSource = dataSource
    }
    
    func fetchUsers(completion: @escaping () -> ()) {
        Network.getContancts { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let users) :
                    // reload data
                    self.dataSource?.users = users
                    break
                case .failure(let error) :
                    print("Parsing error \(error)")
                    break
                }
                completion()
            }
        }
    }
    
}


