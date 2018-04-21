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
    
    var akcije: [Akcija] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = User.currentUser {
            print(user.id)
        }
        
        DispatchQueue.main.async {
            self.loadAkcije()
        }
        
        collectionView.register(UINib(nibName: "AkcijaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AkcijaCollectionViewCell")
        tableView.register(UINib(nibName: "StatusTableViewCell", bundle: nil), forCellReuseIdentifier: "StatusTableViewCell")
    }
    
    
    
    private func loadAkcije() {
        guard let currentUser = User.currentUser else { return }
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "UserAkcije")
        let akcijeTable = client.table(withName: "Akcije")
        
        table.read(with: NSPredicate(format: "UserID == %@", currentUser.id)) { (result, error) in
            if let items = result?.items {
                for item in items {
                    let akcijaId = item["AkcijaID"]
                    akcijeTable.read(withId: akcijaId, completion: { (akcijaDict, error) in
                        if let akcijaDict = akcijaDict, let akcija = Akcija(with: akcijaDict) {
                            self.akcije.append(akcija)
                            self.collectionView.reloadData()
                        }
                    })
                }
            }
        }
        
//        table.read { (result, error) in
//            if let items = result?.items {
//                for item in items {
//                    let akcija = Akcija(with: item)
//                    print(akcija?.id)
//                }
//            } else {
//                print("nece")
//            }
//        }
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return akcije.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: AkcijaCollectionViewCell.self, for: indexPath)
        
        cell.setup(with: akcije[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(ofType: AkcijaDetailViewController.self)
        
        present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ofType: StatusTableViewCell.self, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(ofType: AkcijaDetailViewController.self)
        
        present(vc, animated: true, completion: nil)
    }
}
