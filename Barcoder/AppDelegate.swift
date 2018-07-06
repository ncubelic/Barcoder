//
//  AppDelegate.swift
//  Barcoder
//
//  Created by Nikola on 25/05/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        return true
    }

}

extension AppDelegate {
    
    private func setupAppearance() {
        let navBar = UINavigationBar.appearance()
        let dark = UIColor(named: "GradientDark")!
        let light = UIColor(named: "GradientLight")!
        navBar.setBackgroundImage(applyNavigationGradient(colors: [dark, light]), for: .default)
        navBar.tintColor = .white
        navBar.isTranslucent = false
    }
    
    private func applyNavigationGradient(colors : [UIColor]) -> UIImage? {
        var frameAndStatusBar: CGRect = window!.bounds
        frameAndStatusBar.size.height += 20
        return gradientImage(size: frameAndStatusBar.size, colors: colors)
    }
    
    private func gradientImage(size: CGSize, colors : [UIColor]) -> UIImage? {
        let cgcolors = colors.map { $0.cgColor }
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        defer { UIGraphicsEndImageContext() }
        
        var locations : [CGFloat] = [0.0, 1.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: cgcolors as NSArray as CFArray, locations: &locations) else { return nil }
        context.drawLinearGradient(gradient, start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: size.width, y: 0.0), options: [])
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


