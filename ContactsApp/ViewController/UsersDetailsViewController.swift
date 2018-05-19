//
//  NewContactViewController.swift
//  ContactsApp
//
//  Created by Mesrop Kareyan on 5/19/18.
//  Copyright © 2018 Mesrop Kareyan. All rights reserved.
//

import UIKit
import SDWebImage


enum UserDetailViewControllerType {
    case newUser
    case userDetails
}

class UsersDetailsViewController: UITableViewController {
    
    var userViewModel: UserDetailsViewModel!
    var controllerType: UserDetailViewControllerType!
    
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var firstNameTextFiled: UITextField!
    @IBOutlet weak var lastNameTextFiled: UITextField!
    @IBOutlet weak var phoneTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2;
        userImageView.layer.masksToBounds = true
        guard let type = self.controllerType else {
            fatalError(" \"UserDetailViewControllerType\" is required for UsersDetailsViewController")
        }
        switch type {
          case .newUser:
            textFields.forEach { $0.isEnabled = true}
            notesTextView.isEditable = true
            self.doneButtonItem.isEnabled = false
          case .userDetails:
            textFields.forEach { $0.isEnabled = false }
            notesTextView.isEditable = false
            userImageView.isUserInteractionEnabled = false
            doneButtonItem.isEnabled = false
            configure(for: userViewModel.user)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dissmisKeyboardTap(_:)))
        view.addGestureRecognizer(tap)
        textFields.forEach { $0.delegate = self}
        notesTextView.delegate = self
    }
    
    func configure(for user: User) {
        self.firstNameTextFiled.text =  userViewModel.user.firstName
        self.lastNameTextFiled.text  =  userViewModel.user.lastName
        self.phoneTextFiled.text     =  userViewModel.user.phone
        self.emailTextField.text     =  userViewModel.user.email
        self.notesTextView.text      = userViewModel.user.notes
    }
    
    var textFields: [UITextField] {
        return [
            firstNameTextFiled!,
            lastNameTextFiled!,
            phoneTextFiled!,
            emailTextField!
        ]
    }
    
    //MARK: Actions
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        var user = User()
        user.firstName = firstNameTextFiled.text!
        user.lastName = lastNameTextFiled.text!
        user.phone = phoneTextFiled.text!
        user.email = emailTextField.text!
        user.notes = notesTextView.text!
        self.userViewModel.user = user
        self.userViewModel.saveUserData()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userImageTapped(_ sender: UITapGestureRecognizer) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func dissmisKeyboardTap(_ tap: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        self.doneButtonItem.isEnabled = checkTextInputs()
    }
    
}

//MARK: Text View Delegate
extension UsersDetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView){
        self.doneButtonItem.isEnabled = checkTextInputs()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func checkTextInputs() -> Bool {
        let emptyTextFields =  [firstNameTextFiled,
                                lastNameTextFiled,
                                phoneTextFiled,
                                emailTextField].filter { $0!.text!.isEmpty}
        if emptyTextFields.count > 0 || self.notesTextView.text.isEmpty {
            return false
        }
        return true
    }
}

extension UsersDetailsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextFiled:
            lastNameTextFiled.becomeFirstResponder()
            return false
        case lastNameTextFiled:
            phoneTextFiled.becomeFirstResponder()
            return false
        case phoneTextFiled:
            emailTextField.becomeFirstResponder()
            return false
        case emailTextField:
            notesTextView.becomeFirstResponder()
            return false
        default:
            break
        }
        return true
    }
}

extension UsersDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userImageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
