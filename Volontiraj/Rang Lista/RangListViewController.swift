//
//  RangListViewController.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class RangListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var volonterMjesecLabel: UILabel!
    @IBOutlet weak var volonterMjesecaView: UIView!
    @IBOutlet weak var volonterMjesecaImageView: UIImageView!
    @IBOutlet weak var volonterMjesecaLabel: UILabel!
    @IBOutlet weak var volonterMjesecaBrojSatiLabel: UILabel!
    @IBOutlet weak var trenutniMjesecLabel: UILabel!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsers()
        
        volonterMjesecaImageView.layer.cornerRadius = volonterMjesecaImageView.frame.height / 2
        volonterMjesecaImageView.layer.masksToBounds = true
        
        volonterMjesecaView.layer.cornerRadius = 20
        volonterMjesecaView.backgroundColor = UIColor(white: 240/255, alpha: 1)
        
        tableView.register(UINib(nibName: "RangListTableViewCell", bundle: nil), forCellReuseIdentifier: "RangListTableViewCell")
    }
    
    private func loadUsers() {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "Users")
        
        users = []
        table.read { (result, error) in
            if let items = result?.items {
                for item in items {
                    if let user = User(with: item) {
                        self.users.append(user)
                        self.users.sort { $0.satiVolontiranja > $1.satiVolontiranja }
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            setupUIPojedinci()
        case 1:
            setupUITvrtke()
        default:
            break
        }
    }
    
    private func setupUIPojedinci() {
        volonterMjesecaImageView.image = #imageLiteral(resourceName: "Person")
        volonterMjesecaLabel.text = "Filip Grebenac"
    }
    
    private func setupUITvrtke() {
        volonterMjesecaImageView.image = #imageLiteral(resourceName: "Tvrtka")
        volonterMjesecaLabel.text = "Microsoft"
    }
}

extension RangListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: RangListTableViewCell.self, for: indexPath)
        
        cell.setup(with: users[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
