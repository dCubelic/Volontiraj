//
//  StatusTableViewCell.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    @IBOutlet weak var personImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd.MM."
        return df
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        personImageView.layer.cornerRadius = personImageView.frame.width / 2
        personImageView.layer.masksToBounds = true
    }
    
    func setup(with newsFeed: NewsFeed) {
        switch newsFeed.type {
        case .organizacija:
            statusLabel.text = "\(newsFeed.user.ime) organizira novu akciju: \(newsFeed.akcija.ime)"
        case .pridruzivanje:
            statusLabel.text = "\(newsFeed.user.ime) pridruzio se akciji: \(newsFeed.akcija.ime)"
        }
        dateLabel.text = dateFormatter.string(from: newsFeed.vrijeme)
        personImageView.image = UIImage(named: newsFeed.user.ime) ?? ((newsFeed.user.type == .pojedinac) ? #imageLiteral(resourceName: "Person") : #imageLiteral(resourceName: "defaultCompany"))
    }
}
