//
//  SearchViewController.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var akcijeUBliziniLabel: UILabel!
    
    var akcije: [Akcija] = []
    var nearbyAkcije: [Akcija] = []
    var filteredAkcije: [Akcija] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadNearbyAkcije()
        loadSveAkcije()
        
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        
        if let searchTextField: UITextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.backgroundColor = UIColor(white: 240/255, alpha: 1)
        }
        
        collectionView.register(UINib(nibName: "AkcijaCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AkcijaCollectionViewCell")
    }
    
    private func loadSveAkcije() {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "Akcije")
        
        table.read { (result, error) in
            if let items = result?.items {
                for item in items {
                    if let akcija = Akcija(with: item) {
                        self.akcije.append(akcija)
                    }
                }
            }
        }
        
    }
    
    private func loadNearbyAkcije() {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "Akcije")
        
        table.read { (result, error) in
            if let items = result?.items {
                for item in items {
                    if let akcija = Akcija(with: item) {
                        self.nearbyAkcije.append(akcija)
                        self.filteredAkcije = self.nearbyAkcije
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        
    }

}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width / 2
        let height = (collectionView.frame.height - 10) / 2
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredAkcije.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ofType: AkcijaCollectionViewCell.self, for: indexPath)
        
        cell.setup(with: filteredAkcije[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(ofType: AkcijaDetailViewController.self)
        vc.akcija = akcije[indexPath.row]
        
        present(vc, animated: true, completion: nil)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredAkcije = nearbyAkcije
        collectionView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            filteredAkcije = nearbyAkcije
        } else {
            filteredAkcije = akcije.filter({ (akcija) -> Bool in
                akcija.ime.lowercased().contains(searchText.lowercased())
            })
        }
        collectionView.reloadData()
    }
}
