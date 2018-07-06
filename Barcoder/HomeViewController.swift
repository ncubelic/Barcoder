//
//  HomeViewController.swift
//  Barcoder
//
//  Created by Nikola on 25/05/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func generateBarcodeAction(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BarcodeViewController") as! BarcodeViewController
        
        if isFormValid() {
            guard let amount = amountTextField.text, let description = descriptionTextField.text else { return }
            vc.barcodeDynamicData = BarcodeData(amount: amount, description: description)
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
}

extension HomeViewController {
    
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
}
