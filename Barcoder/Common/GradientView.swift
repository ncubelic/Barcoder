//
//  GradientView.swift
//  Barcoder
//
//  Created by Nikola on 06/07/2018.
//  Copyright © 2018 Nikola. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class GradientView: UIView {
    
    var gradientLayer: CAGradientLayer!
    
    @IBInspectable var topColor: UIColor = .black {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .clear {
        didSet {
            updateUI()
        }
    }
    
    @IBInspectable var bottomYPoint: CGFloat = 0.6 {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        setNeedsDisplay()
    }
    
    func setupGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = .zero
        gradientLayer.endPoint = CGPoint(x: 0, y: bottomYPoint)
        layer.addSublayer(gradientLayer)
    }
}
