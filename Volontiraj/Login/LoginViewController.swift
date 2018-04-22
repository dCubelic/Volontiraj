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

        navigationController?.navigationBar.tintColor = .white
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func loginAction(_ sender: Any) {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "Users")
        
        guard let username = usernameTextField.text, let pass = passwordTextField.text else { return }
        
        table.read(with: NSPredicate(format: "Mail == %@ and Password == %@", username, pass)) { (result, error) in
            if let items = result?.items {
                if items.count == 1 {
                    User.currentUser = User(with: items[0])
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                    self.present(vc, animated: true, completion: nil)
                } else {
//                    print("los count")
                }
            }
        }
    }
}