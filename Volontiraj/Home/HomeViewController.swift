//
//  HomeViewController.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var novaAkcijaButton: UIButton!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var emptyCollectionLabel: UILabel!
    
    
    var akcije: [Akcija] = []
    var newsFeed: [NewsFeed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = User.currentUser else { return }
        
        if currentUser.type == .organizacija {
            novaAkcijaButton.isHidden = false
        } else {
            novaAkcijaButton.isHidden = true
        }
        
        DispatchQueue.main.async {
            self.loadAkcije()
            self.loadNewsFeed()
        }
        
        collectionView.register(UINib(nibName: "AkcijaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AkcijaCollectionViewCell")
        tableView.register(UINib(nibName: "StatusTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusTableViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadAkcije), name: Notification.Name("promjenaAkcije"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadNewsFeed), name: Notification.Name("noviStatus"), object: nil)
    }
    
    
    
    @objc private func loadAkcije() {
        guard let currentUser = User.currentUser else { return }
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "UserAkcije")
        let akcijeTable = client.table(withName: "Akcije")
        
        akcije = []
        collectionView.reloadData()
        table.read(with: NSPredicate(format: "UserID == %@", currentUser.id)) { (result, error) in
            if let items = result?.items {
                for item in items {
                    let akcijaId = item["AkcijaID"]
                    akcijeTable.read(withId: akcijaId ?? "", completion: { (akcijaDict, error) in
                        if let akcijaDict = akcijaDict, let akcija = Akcija(with: akcijaDict), akcija.vrijeme > Date() {
                            self.akcije.append(akcija)
                            self.akcije.sort(by: { $0.vrijeme < $1.vrijeme } )
                            self.collectionView.reloadData()
                        }
                    })
                }
            }
        }
    }
    
    @objc private func loadNewsFeed() {
        guard let currentUser = User.currentUser else { return }
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let followsTable = client.table(withName: "FollowsTable")
        let newsFeedTable = client.table(withName: "NewsFeed")
        
        newsFeed = []
        tableView.reloadData()
        followsTable.read(with: NSPredicate(format: "UserID == %@", currentUser.id)) { (result, error) in
            if let items = result?.items {
                for item in items {
                    let userID = item["UserID2"] as! String
                    newsFeedTable.read(with: NSPredicate(format: "UserID == %@", userID), completion: { (result, error) in
                        if let items = result?.items {
                            for item in items {
                                self.loadPerson(item: item)
                            }
                        }
                    })
                }
            }
        }
    }
    
    private func loadPerson(item: [AnyHashable: Any]) {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let userTable = client.table(withName: "Users")
        
        userTable.read(withId: item["UserID"] ?? "") { (dict, error) in
            if let dict = dict, let user = User(with: dict) {
                self.loadAkcija(user: user, item: item)
            }
        }
    }
    
    private func loadAkcija(user: User, item: [AnyHashable: Any]) {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let akcijeTable = client.table(withName: "Akcije")
        
        akcijeTable.read(withId: item["AkcijaID"] ?? "") { (dict, error) in
            if let dict = dict, let akcija = Akcija(with: dict) {
                self.loadFeed(user: user, akcija: akcija, item: item)
            }
        }
    }
    
    private func loadFeed(user: User, akcija: Akcija, item: [AnyHashable: Any]) {
        if let vrijeme = item["vrijeme"] as? Date,
            let type = item["type"] as? Int {
            newsFeed.append(NewsFeed(user: user, akcija: akcija, vrijeme: vrijeme, type: type))
            self.newsFeed.sort(by: { $0.vrijeme > $1.vrijeme })
            self.tableView.reloadData()
        }
    }

    @IBAction func novaAkcijaAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(ofType: NovaAkcijaViewController.self)
        
        present(vc, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if akcije.count == 0 {
            emptyCollectionLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyCollectionLabel.isHidden = true
            collectionView.isHidden = false
        }
        return akcije.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: AkcijaCollectionViewCell.self, for: indexPath)
        
        cell.setup(with: akcije[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(ofType: AkcijaDetailViewController.self)
        vc.akcija = akcije[indexPath.row]
        
        present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsFeed.count == 0 {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        } else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
        return newsFeed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: StatusTableViewCell.self, for: indexPath)

        cell.setup(with: newsFeed[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(ofType: AkcijaDetailViewController.self)
        vc.akcija = newsFeed[indexPath.row].akcija
        
        present(vc, animated: true, completion: nil)
    }
}
