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
        guard let amount = amountTextField.text, let description = descriptionTextField.text else { return }
        vc.barcodeDynamicData = BarcodeData(amount: amount, description: description)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func settingsAction(_ sender: Any) {
        let settingsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let navVC = UINavigationController(rootViewController: settingsViewController)
        present(navVC, animated: true, completion: nil)
    }
}
