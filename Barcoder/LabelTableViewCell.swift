//
//  LabelTableViewCell.swift
//  Barcoder
//
//  Created by Nikola on 06/07/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with item: Item) {
        leftLabel.text = item.title
        rightLabel.text = item.value
    }
}
