//
//  RangListTableViewCell.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class RangListTableViewCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var imeLabel: UILabel!
    @IBOutlet weak var brojSatiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        personImageView.layer.cornerRadius = personImageView.frame.height / 2
        personImageView.layer.masksToBounds = true
    }
    
    func setup(with user: User) {
        imeLabel.text = "\(user.ime) \(user.prezime)"
        brojSatiLabel.text = "\(user.satiVolontiranja)"
        personImageView.image = UIImage(named: user.ime) ?? ((user.type == .pojedinac) ? #imageLiteral(resourceName: "Person") : #imageLiteral(resourceName: "defaultCompany"))
    }
    
}
