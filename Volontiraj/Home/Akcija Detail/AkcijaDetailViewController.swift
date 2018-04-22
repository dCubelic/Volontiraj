//
//  AkcijaDetailViewController.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class AkcijaDetailViewController: UIViewController {
    
    @IBOutlet weak var imeAkcijeLabel: UILabel!
    @IBOutlet weak var imeOrganizacijeLabel: UILabel!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var goingButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM."
        return df
    }()
    
    var akcija: Akcija?
    var users: [User] = []
    var going = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let akcija = akcija else { return }
        
        DispatchQueue.global().async {
            self.loadUsers()
        }
        
        imeAkcijeLabel.text = akcija.ime
        imeOrganizacijeLabel.text = akcija.organizator
        numberOfPeopleLabel.text = "\(akcija.brojLjudi)/\(akcija.potrebnoLjudi)"
        dateLabel.text = dateFormatter.string(from: akcija.vrijeme)
        descriptionLabel.text = akcija.opis
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadUsers), name: Notification.Name("promjenaAkcije"), object: nil)
    }
    
    @objc private func loadUsers() {
        guard let akcija = akcija else { return }
        
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "UserAkcije")
        let userTable = client.table(withName: "Users")
        
        users = []
        collectionView.reloadData()
        table.read(with: NSPredicate(format: "AkcijaID == %@", akcija.id)) { (result, error) in
            if let items = result?.items {
                for item in items {
                    let userID = item["UserID"] as! String
                    userTable.read(withId: userID, completion: { (dict, error) in
                        if let dict = dict, let user = User(with: dict), let currentUser = User.currentUser {
                            if user.id == currentUser.id {
                                self.going = true
                                self.goingButton.setImage(#imageLiteral(resourceName: "done"), for: .normal)
                                self.goingButton.alpha = 0.7
                            }
                            self.users.append(user)
                            self.collectionView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    @IBAction func goingAction(_ sender: Any) {
        if going {
            goingButton.setImage(#imageLiteral(resourceName: "notDone"), for: .normal)
            goingButton.alpha = 0.3
            
            removeUserFromUserAkcije()
            going = false
        } else {
            goingButton.setImage(#imageLiteral(resourceName: "done"), for: .normal)
            goingButton.alpha = 0.7
            
            addUserToAkcija()
            going = true
        }
        
    }
    
    private func removeUserFromUserAkcije() {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "UserAkcije")
        
        guard let currentUser = User.currentUser, let akcija = akcija else { return }
        
        table.read(with: NSPredicate(format: "UserID == %@ and AkcijaID == %@", currentUser.id, akcija.id)) { (result, error) in
            let id = result?.items![0]["id"]
            table.delete(withId: id, completion: { (id, error) in
                NotificationCenter.default.post(name: Notification.Name("promjenaAkcije"), object: nil)
            })
            
        }
    }
    
    private func addUserToAkcija() {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "UserAkcije")
        
        guard let currentUser = User.currentUser, let akcija = akcija else { return }
        
        let newItem = [
            "UserID": currentUser.id,
            "AkcijaID": akcija.id
        ]
        table.insert(newItem) { (dict, error) in
            NotificationCenter.default.post(name: Notification.Name("promjenaAkcije"), object: nil)
        }
    }
    
    @IBAction func closeAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AkcijaDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: GoingPeopleCollectionViewCell.self, for: indexPath)
        
        cell.setup(with: users[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let currentUser = User.currentUser {
            if currentUser.id == users[indexPath.row].id {
                return
            }
        }
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(ofType: ProfilePopupViewController.self)
        vc.user = users[indexPath.row]
        vc.modalPresentationStyle = .overCurrentContext
        
        present(vc, animated: false, completion: nil)
    }
}
