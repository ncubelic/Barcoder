//
//  BTextField.swift
//  Barcoder
//
//  Created by Nikola on 13/07/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import UIKit

class BTextField: UITextField {

    override func draw(_ rect: CGRect) {
        
        let color = UIColor(named: "GradientDark")!
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: 1)
        bottomLine.backgroundColor = color.cgColor
        layer.addSublayer(bottomLine)
    }

}
