//
//  TextFieldTableViewCell.swift
//  Barcoder
//
//  Created by Nikola on 06/07/2018.
//  Copyright © 2018 Me All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.isEnabled = false
        textField.returnKeyType = .next
    }
    
    func setup(with item: Item) {
        leftLabel.text = item.title
        textField.placeholder = item.placeholder
        textField.text = item.value
        textField.keyboardAppearance = .dark
    }
    
    func beginInput(with delegate: UITextFieldDelegate) {
        textField.isEnabled = true
        textField.becomeFirstResponder()
        textField.delegate = delegate
    }
}
