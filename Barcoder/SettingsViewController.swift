//
//  SettingsViewController.swift
//  Barcoder
//
//  Created by Nikola on 06/07/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LabelTableViewCell", bundle: nil), forCellReuseIdentifier: "LabelTableViewCell")
        tableView.register(UINib(nibName: "TextFieldTableViewCell", bundle: nil), forCellReuseIdentifier: "TextFieldTableViewCell")
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        // TODO: implement save action
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
        return "PODACI O VLASNIKU RAČUNA"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Barkod na uplatnici sadržavati će upisane podatke."
    }
}


// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let currentIndexPath = currentIndexPath else { return }
        items[currentIndexPath.row].value = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard
            let currentIndexPath = currentIndexPath,
            currentIndexPath.row < items.count - 1,
            items[currentIndexPath.row + 1].type == .textField
            else {
                view.endEditing(true)
                return false
        }
        
        let nextIndex = currentIndexPath.row + 1
        let nextIndexPath = IndexPath(row: nextIndex, section: 0)
        let nextCell = tableView.cellForRow(at: nextIndexPath) as! TextFieldTableViewCell
        nextCell.beginInput(with: self)
        self.currentIndexPath = nextIndexPath
        return true
    }
}
