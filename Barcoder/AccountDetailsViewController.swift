//
//  AccountDetailsViewController.swift
//  Barcoder
//
//  Created by Nikola on 25/05/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import UIKit

class AccountDetailsViewController: UIViewController {

    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var iban: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var referenceNumberTextField: UITextField!
    @IBOutlet weak var paymentSthTextField: UITextField!
    
    private var account: Account!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let data = UserDefaults.standard.object(forKey: "account") as? Data {
            account = NSKeyedUnarchiver.unarchiveObject(with: data) as! Account
        } else {
//            account = Account(currency: "HRK", payeeName: "Nikola Cubelic", payeeAddress: "Mladena Kerstnera 42", payeeCity: "10410 Velika Gorica", payeeIBAN: "HR0724070003206844371", paymentModel: "HR00", referenceNumber: "", something: "")
            account = Account()
        }
        fillForm()
    }
    
    private func fillForm() {
        currencyTextField.text = account.currency
        nameTextField.text = account.payeeName
        addressTextField.text = account.payeeAddress
        cityTextField.text = account.payeeCity
        iban.text = account.payeeIBAN
        modelTextField.text = account.paymentModel
        referenceNumberTextField.text = account.paymentReferenceNumber
        paymentSthTextField.text = account.paymentSomething
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard
            let currency = currencyTextField.text,
            let payeeName = nameTextField.text,
            let address = addressTextField.text,
            let city = cityTextField.text,
            let iban = iban.text,
            let model = modelTextField.text,
            let reference = referenceNumberTextField.text,
            let something = paymentSthTextField.text
            else { return }
        account = Account(currency: currency, payeeName: payeeName, payeeAddress: address, payeeCity: city, payeeIBAN: iban, paymentModel: model, referenceNumber: reference, something: something)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: account)
        UserDefaults.standard.set(data, forKey: "account")
        dismiss(animated: true, completion: nil)
    }
}
