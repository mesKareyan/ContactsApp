//
//  UserTableViewCell.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var user: User! {
        didSet {
            self.textLabel?.text = user.firstName + " " + user.lastName
            self.detailTextLabel?.text = user.phone
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        imageView?.layer.cornerRadius = imageView!.bounds.width / 2
        imageView?.clipsToBounds = true
    }
    
    


}

