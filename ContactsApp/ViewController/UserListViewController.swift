//
//  UserListViewController.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit
import JGProgressHUD

class UsersListViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var hud: JGProgressHUD!
    
    struct Segue {
        private init(){}
        static let  showNewUserPage = "showNewUserPage"
        static let  showUserDetails = "showUserDetails"
    }
    
    let dataSource = UsersListDataSource()
    lazy var viewModel : UsersViewModel = {
        let viewModel = UsersViewModel(dataSource: dataSource)
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.showLoadingHUD()
        self.viewModel.fetchUsers { [unowned self] in
            self.tableView.reloadData()
            self.hud?.dismiss()
        }
    }
    
    func showLoadingHUD() {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
    }
    
    //MARK: - Actions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard  let identifier = segue.identifier else { return }
        switch identifier {
        case Segue.showNewUserPage:
            let newUserController = segue.destination as! UsersDetailsViewController
            newUserController.controllerType = .newUser
            newUserController.userViewModel = UserDetailsViewModel()
        case Segue.showUserDetails:
            let userDetailsController = segue.destination as! UsersDetailsViewController
            userDetailsController.controllerType = .userDetails
            let index = sender as! Int
            let user = viewModel.dataSource!.users[index]
            userDetailsController.userViewModel = UserDetailsViewModel(with: user)
        default:
            
            break
        }
    }
}

extension UsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Segue.showUserDetails, sender: indexPath.row)
    }
    
}
