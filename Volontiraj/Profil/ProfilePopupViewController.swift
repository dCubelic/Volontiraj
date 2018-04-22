//
//  ProfilePopupViewController.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class ProfilePopupViewController: UIViewController {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var pratiButton: UIButton!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isFollowing()
        
        guard let user = user else { return }
        
        personImageView.layer.cornerRadius = personImageView.frame.height / 2
        personImageView.layer.masksToBounds = true
        
        nameLabel.text = "\(user.ime) \(user.prezime)"
        
        popupView.layer.cornerRadius = 20
        popupView.layer.masksToBounds = true
    }
    
    private func isFollowing() {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "FollowsTable")
        
        guard let user = user, let currentUser = User.currentUser else { return }
        
        table.read(with: NSPredicate(format: "UserID == %@ and UserID2 == %@", currentUser.id, user.id)) { (result, error) in
            if let items = result?.items {
                if items.count >= 1 {
                    self.pratiButton.isEnabled = false
                    self.pratiButton.alpha = 0.3
                } else if items.count == 0 {
                    self.pratiButton.isEnabled = true
                    self.pratiButton.alpha = 1
                } else {
                    print("zas sam tu?")
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func pratiAction(_ sender: Any) {
        guard let user = user, let currentUser = User.currentUser else { return }
        
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "FollowsTable")
        
        let newItem = [
            "UserID": currentUser.id,
            "UserID2": user.id
        ]
        table.insert(newItem) { (dict, error) in
            self.pratiButton.isEnabled = false
            self.pratiButton.alpha = 0.3
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
}
