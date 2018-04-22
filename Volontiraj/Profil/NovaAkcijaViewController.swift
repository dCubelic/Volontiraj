//
//  NovaAkcijaViewController.swift
//  Volontiraj
//
//  Created by dominik on 22/04/2018.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import UIKit

class NovaAkcijaViewController: UIViewController {

    @IBOutlet weak var imeTextField: UITextField!
    @IBOutlet weak var brojLjudiTextField: UITextField!
    @IBOutlet weak var opisTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.minimumDate = Date()
    }

    @IBAction func datePickerChanged(_ sender: Any) {
        selectedDate = datePicker.date
    }
    
    @IBAction func dodajAction(_ sender: Any) {
        guard let ime = imeTextField.text, let brojLjudi = brojLjudiTextField.text, let opis = opisTextView.text, let currentUser = User.currentUser else { return }
        
        let client = MSClient(applicationURLString: "https://volontiraj.azurewebsites.net")
        let table = client.table(withName: "Akcije")
        
        let newItem: [String: Any] = [
            "Ime": ime,
            "Organizator": currentUser.ime,
            "Vrijeme": selectedDate,
            "Potrebno_volontera": brojLjudi,
            "Lokacija": "abc",
            "Opis_akcije": opis,
        ]
        table.insert(newItem) { (dict, error) in
            NotificationCenter.default.post(name: Notification.Name("novaAkcija"), object: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func odustaniAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
