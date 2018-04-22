//
//  AkcijaCollectionViewCell.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class AkcijaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imeAkcijeLabel: UILabel!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageViewLabel: UIImageView!
    @IBOutlet weak var organizationNameLabel: UILabel!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM."
        return df
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    func setup(with akcija: Akcija) {
        imageViewLabel.image = UIImage(named: akcija.ime) ?? #imageLiteral(resourceName: "default")
        imeAkcijeLabel.text = akcija.ime
        numberOfPeopleLabel.text = "\(akcija.brojLjudi)/\(akcija.potrebnoLjudi)"
        dateLabel.text = dateFormatter.string(from: akcija.vrijeme)
        organizationNameLabel.text = akcija.organizator
    }
    

}
