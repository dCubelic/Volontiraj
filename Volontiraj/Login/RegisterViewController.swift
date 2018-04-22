//
//  RegisterViewController.swift
//  Volontiraj
//
//  Created by dominik on 22/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var imeTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        imeTextField.delegate = self
        secondTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            imeTextField.isHidden = false
            secondTextField.placeholder = "Prezime"
            secondTextField.keyboardType = .default
        case 1:
            imeTextField.isHidden = true
            secondTextField.placeholder = "Ime organizacije"
            secondTextField.keyboardType = .default
        case 2:
            imeTextField.isHidden = false
            secondTextField.placeholder = "Broj volontera"
            secondTextField.keyboardType = .numberPad
        default:
            break
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            guard let ime = imeTextField.text, let prezime = secondTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else { return }
            
            
        case 1:
            guard let ime = secondTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else { return }
        case 2:
            guard let ime = imeTextField.text, let brojVolontera = secondTextField.text, let email = emailTextField.text, let password = passwordTextField.text, let repeatPassword = repeatPasswordTextField.text else { return }
        default:
            return
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == imeTextField {
            secondTextField.becomeFirstResponder()
        } else if textField == secondTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            repeatPasswordTextField.becomeFirstResponder()
        } else if textField == repeatPasswordTextField {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
