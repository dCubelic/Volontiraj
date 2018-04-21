//
//  UserAkcije.swift
//  Volontiraj
//
//  Created by dominik on 21/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

class UserAkcija {
    var user: User?
    var akcija: Akcija?
    
    func setup(with dict: [AnyHashable: Any]) {
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        var table = client.table(withName: "Users")
        
        table.read(withId: dict["Userid"]) { (dict2, error) in
            if let dict2 = dict2, let user = User(with: dict2) {
                self.user = user
            }
        }
        
        table = client.table(withName: "Akcije")
        
        table.read(withId: dict["Akcijaid"]) { (dict2, error) in
            if let dict2 = dict2, let akcija = Akcija(with: dict2) {
                self.akcija = akcija
            }
        }
    
    }
    
    
}
