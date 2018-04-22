//
//  GoingPeopleCollectionViewCell.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class GoingPeopleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
    }
    
    func setup(with user: User) {
        nameLabel.text = "\(user.ime) \(user.prezime)"
        imageView.image = UIImage(named: user.ime) ?? ((user.type == .pojedinac) ? #imageLiteral(resourceName: "Person") : #imageLiteral(resourceName: "defaultCompany"))
    }
}
