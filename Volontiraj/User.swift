//
//  User.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

enum UserType: String {
    case pojedinac, tvrtka, organizacija
}

class User {
    var id: String
    var ime: String
    var prezime: String
    var mail: String
    var type: UserType
    var satiVolontiranja: Int
    
    static var currentUser: User?
    
    init?(with dict: [AnyHashable: Any]) {
        guard let id = dict["id"] as? String,
            let ime = dict["Ime"] as? String,
            let prezime = dict["Prezime"] as? String,
            let mail = dict["mail"] as? String,
            let typeString = dict["type"] as? String,
            let satiVolontiranja = dict["Sati_volontiranja"] as? Int
        else { return nil }
        
        self.id = id
        self.ime = ime
        self.prezime = prezime
        self.mail = mail
        self.type = UserType(rawValue: typeString) ?? .pojedinac
        self.satiVolontiranja = satiVolontiranja
    }
    
//    private func parseType(typeString: String) -> UserType {
//        if let type = UserType(rawValue: typeString) {
//            return type
//        }
//        return .pojedinac
//    }
}
