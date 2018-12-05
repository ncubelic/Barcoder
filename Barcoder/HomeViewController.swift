//
//  HomeViewController.swift
//  Barcoder
//
//  Created by Nikola on 25/05/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var amountTextField: BTextField!
    @IBOutlet weak var descriptionTextField: BTextField!
    
    private var currentAmount: NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountTextField.textAlignment = .right
        descriptionTextField.textAlignment = .right
        amountTextField.addTarget(self, action: #selector(amountDidChange(_:)), for: .editingChanged)
    }
    
    @objc func amountDidChange(_ textField: UITextField) {
        if let amountString = textField.text {
            textField.text = currencyInputFormatting(amountString)
        }
    }
    
    @IBAction func generateBarcodeAction(_ sender: Any) {
        if isFormValid() {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BarcodeViewController") as! BarcodeViewController
            guard let _ = amountTextField.text, let description = descriptionTextField.text else { return }
            let amountInLipas = Int(currentAmount.floatValue * 100)
            vc.barcodeDynamicData = BarcodeData(amount: String(amountInLipas), description: description)
            navigationController?.pushViewController(vc, animated: true)
            view.endEditing(true)
        }
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let navVC = UINavigationController(rootViewController: settingsViewController)
        present(navVC, animated: true, completion: nil)
        view.endEditing(true)
    }
    
    @IBAction func historyAction(_ sender: Any) {
        let historyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryViewController")
        let navVC = UINavigationController(rootViewController: historyVC)
        present(navVC, animated: true, completion: nil)
    }
}

extension HomeViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func isFormValid() -> Bool {
        guard
            let amount = amountTextField.text, !amount.isEmpty,
            let description = descriptionTextField.text, !description.isEmpty
            else {
                showAlert(withMessage: "Molimo upišite iznos i opis plaćanja.")
                return false
            }
        return true
    }
    
    private func showAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Greška", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // formatting text for currency textField
    private func currencyInputFormatting(_ string: String) -> String {
        
        var number: NSNumber
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "kn"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = string
        
        // remove from String: "kn", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, string.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        currentAmount = number
        return formatter.string(from: number)!
    }
}
