//
//  HistoryTableViewCell.swift
//  Barcoder
//
//  Created by Nikola on 06/07/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var barcodeDescriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    let numberFormatter = NumberFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "Kn"
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.currencyGroupingSeparator = "."
        numberFormatter.alwaysShowsDecimalSeparator = true
        numberFormatter.locale = Locale(identifier: "hr_HR")
    }

    func setup(with historyItem: History) {
        barcodeDescriptionLabel.text = historyItem.paymentDescription
        
        amountLabel.text = numberFormatter.string(from: NSNumber(value: historyItem.amount))
        if let date = historyItem.date {
            dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .short, timeStyle: .none)
        }
    }
}
