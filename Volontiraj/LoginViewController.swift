//
//  LoginViewController.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loginAction(_ sender: Any) {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "Users")
        
        guard let username = usernameTextField.text, let pass = passwordTextField.text else { return }
        
        table.read(with: NSPredicate(format: "Mail == %@ and Password == %@", username, pass)) { (result, error) in
            if let items = result?.items {
                if items.count == 1 {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
                    self.present(vc, animated: true, completion: nil)
                } else {
//                    print("los count")
                }
            }
        }
    }
}
