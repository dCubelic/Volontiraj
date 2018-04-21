//
//  Akcija.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

class Akcija {
    var id: String
    var ime: String
    var organizator: String
    var vrijeme: Date
    var brojLjudi: Int
    var lokacija: String
    var opis: String
    var odobreno: Bool
    var potrebnoLjudi: Int
    
    init?(with dict: [AnyHashable: Any]) {
        guard let id = dict["ID"] as? String,
            let ime = dict["Ime"] as? String,
            let organizator = dict["Organizator"] as? String,
            let vrijeme = dict["Vrijeme"] as? Date,
            let brojLjudi = dict["Broj_volontera"] as? Int,
            let lokacija = dict["Lokacija"] as? String,
            let opis = dict["Opis_akcije"] as? String,
            let odobreno = dict["Odobreno"] as? Bool,
            let potrebnoLjudi = dict["Potrebno_volontera"] as? Int
            else { return nil }
        
        self.id = id
        self.ime = ime
        self.organizator = organizator
        self.vrijeme = vrijeme
        self.brojLjudi = brojLjudi
        self.lokacija = lokacija
        self.opis = opis
        self.odobreno = odobreno
        self.potrebnoLjudi = potrebnoLjudi
    }
}

