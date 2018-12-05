//
//  SettingsViewController.swift
//  Barcoder
//
//  Created by Nikola on 06/07/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

enum ItemType {
    case textField
    case label
    case picker
}

struct Item {
    var title: String
    var placeholder: String
    var value: String
    var type: ItemType
}

struct ValidationResult {
    var isValid: Bool
    var message: String?
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Item] = [
        Item(title: "Valuta", placeholder: "", value: "HRK", type: .label),
        Item(title: "Vlasnik računa", placeholder: "Ivo Ivić", value: "", type: .textField),
        Item(title: "Adresa", placeholder: "Upiši adresu", value: "", type: .textField),
        Item(title: "Poštanski broj i mjesto", placeholder: "Upiši", value: "", type: .textField),
        Item(title: "IBAN", placeholder: "HR1234567890123000000", value: "", type: .textField),
        Item(title: "Model plaćanja", placeholder: "00", value: "00", type: .picker),
        Item(title: "Poziv na broj", placeholder: "", value: "", type: .textField),
        Item(title: "Šifra namjene", placeholder: "", value: "", type: .textField)
    ]
    
    private var currentIndexPath: IndexPath?
    private var account: Account?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
        
        if let data = UserDefaults.standard.object(forKey: "account") as? Data {
            guard let acc = NSKeyedUnarchiver.unarchiveObject(with: data) as? Account else { return }
            account = acc
            fillData()
        } else {
            account = Account()
        }
    }
    
    private func fillData() {
        guard let account = account else { return }
        items[0].value = account.currency
        items[1].value = account.payeeName
        items[2].value = account.payeeAddress
        items[3].value = account.payeeCity
        items[4].value = account.payeeIBAN
        items[5].value = account.paymentModel
        items[6].value = account.paymentReferenceNumber
        items[7].value = account.paymentSomething
        tableView.reloadData()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        view.endEditing(true)
        let currency = items[0].value
        let payeeName = items[1].value
        let address = items[2].value
        let city = items[3].value
        let iban = items[4].value
        let model = items[5].value
        let reference = items[6].value
        let something = items[7].value
        
        let account = Account(currency: currency, payeeName: payeeName, payeeAddress: address, payeeCity: city, payeeIBAN: iban, paymentModel: model, referenceNumber: reference, something: something)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: account)
        UserDefaults.standard.set(data, forKey: "account")
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - UITableView Datasource

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        
        switch item.type {
        case .label:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as! LabelTableViewCell
            cell.setup(with: item)
            return cell
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            cell.setup(with: item)
            cell.textField.tag = indexPath.row
            return cell
        case .picker:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath) as! LabelTableViewCell
            cell.setup(with: item)
            return cell
        }
    }
}


// MARK: - UITableView Delegate

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        currentIndexPath = indexPath
        
        let selectedItem = items[indexPath.row]
        switch selectedItem.type {
        case .textField:
            let cell = tableView.cellForRow(at: indexPath) as! TextFieldTableViewCell
            cell.beginInput(with: self)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "PODACI O VLASNIKU BANKOVNOG RAČUNA"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Barkod na uplatnici sadržavati će upisane podatke. Skeniranjem barkoda bankovnom aplikacijom, popuniti će se podaci o plaćanju."
    }
}


// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        items[textField.tag].value = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let validationResult = validate(textField)
        
        guard validationResult.isValid else {
            showAlert(with: validationResult.message)
            return false
        }
        
        guard
            textField.tag < items.count - 1,
            items[textField.tag + 1].type == .textField
            else {
                view.endEditing(true)
                return false
        }
        
        let nextIndex = textField.tag + 1
        let nextIndexPath = IndexPath(row: nextIndex, section: 0)
        let nextCell = tableView.cellForRow(at: nextIndexPath) as! TextFieldTableViewCell
        nextCell.beginInput(with: self)
        self.currentIndexPath = nextIndexPath
        return true
    }
    
    private func showAlert(with message: String?) {
        let alert = UIAlertController(title: "Greška", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func validate(_ textField: UITextField) -> ValidationResult {
        
        var result = ValidationResult(isValid: false, message: nil)
        
        switch textField.tag {
        case 1:
            // vlasnik racuna
            result.message = "Vlasnik računa je obavezno polje (MAX. 25 znakova)"
            guard let text = textField.text, !text.isEmpty else { return result }
            result.isValid = (text.count <= 25 && text.count > 0)
        case 2:
            // adresa
            guard let text = textField.text else {
                return result
            }
            result.isValid = text.count <= 25
        case 3:
            // postanski broj i mjesto
            guard let text = textField.text else {
                return result
            }
            result.isValid = text.count <= 27
        case 4:
            // iban
            result.message = "IBAN je obavezno polje (MAX. 21 znakova)"
            guard let text = textField.text, !text.isEmpty else { return result }
            result.isValid = (text.count <= 21 && text.count > 0)
        case 6:
            // poziv na broj
            // <= 22 znaka
            guard let text = textField.text else {
                return result
            }
            result.isValid = text.count <= 22
        case 7:
            // sifra namjene
            // <=4 znaka
            guard let text = textField.text else {
                return result
            }
            result.isValid = text.count <= 4
        default:
            return result
        }
        return result
    }
}
