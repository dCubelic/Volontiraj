//
//  NewsFeed.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

enum NewsFeedType: Int {
    case pridruzivanje = 0, organizacija = 1
}

class NewsFeed {
    var user: User
    var akcija: Akcija
    var vrijeme: Date
    var type: NewsFeedType
    
    init(user: User, akcija: Akcija, vrijeme: Date, type: Int) {
        self.user = user
        self.akcija = akcija
        self.vrijeme = vrijeme
        self.type = NewsFeedType(rawValue: type) ?? .pridruzivanje
    }
}
