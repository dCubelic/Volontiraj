//
//  ProfilViewController.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class ProfilViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var personNameLabel: UILabel!
    @IBOutlet weak var brojSatiLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var akcije: [Akcija] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserAkcije()
        
        guard let currentUser = User.currentUser else { return }
        
        personImageView.image = UIImage(named: currentUser.ime) ?? #imageLiteral(resourceName: "Person")
        personNameLabel.text = "\(currentUser.ime) \(currentUser.prezime)"
        brojSatiLabel.text = "\(currentUser.satiVolontiranja)"
        
        personImageView.layer.cornerRadius = personImageView.frame.height / 2
        personImageView.layer.masksToBounds = true
        
        collectionView.register(UINib(nibName: "AkcijaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AkcijaCollectionViewCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadUserAkcije), name: Notification.Name("promjenaAkcije"), object: nil)
    }
    
    @objc private func loadUserAkcije() {
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
                        if let akcijaDict = akcijaDict, let akcija = Akcija(with: akcijaDict) {
                            self.akcije.append(akcija)
                            self.collectionView.reloadData()
                        }
                    })
                }
            }
        }
        
    }
    
    @IBAction func novaAkcijaAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(ofType: NovaAkcijaViewController.self)
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func odjavaAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension ProfilViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - 20
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if akcije.count == 0 {
            emptyLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyLabel.isHidden = true
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
        
        self.present(vc, animated: true, completion: nil)
    }
}
