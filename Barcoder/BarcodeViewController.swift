//
//  BarcodeViewController.swift
//  Barcoder
//
//  Created by Nikola on 25/05/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import UIKit

class BarcodeViewController: UIViewController {
  
  @IBOutlet weak var barcodeImageView: UIImageView!
  
  var barcodeDynamicData: BarcodeData!
  private var barcodeImage: UIImage?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //        let account = Account(currency: "HRK", payeeName: "Nikola Cubelic", payeeAddress: "Mladena Kerstnera 42", payeeCity: "10410 Velika Gorica", payeeIBAN: "HR0724070003206844371", paymentModel: "HR99", paymentReferenceNumber: "", paymentSomething: "")
    let account = Account(currency: "HRK", payeeName: "Nikola Cubelic", payeeAddress: "Mladena Kerstnera 42", payeeCity: "10410 Velika Gorica", payeeIBAN: "HR0724070003206844371", paymentModel: "HR00", referenceNumber: "", something: "")
    generateBarcode(with: account, dynamicData: barcodeDynamicData)
  }
  
  private func generateBarcode(with account: Account, dynamicData: BarcodeData) {
    let formattedAmount = dynamicData.amount.formatForHRK()
    let string = "HRVHUB30\n" +
      "\(account.currency)\n" +
      "\(formattedAmount)\n" +
      "\n" +
      "\n" +
      "\n" +
      "\(account.payeeName)\n" +
      "\(account.payeeAddress)\n" +
      "\(account.payeeCity)\n" +
      "\(account.payeeIBAN)\n" +
      "\(account.paymentModel)\n" +
      "\(account.paymentReferenceNumber)\n" +
      "COST\n" +
    "\(dynamicData.description)\n"
    print(string)
    let data = string.data(using: String.Encoding.ascii)
    
    if let filter = CIFilter(name: "CIPDF417BarcodeGenerator") {
      filter.setValue(data, forKey: "inputMessage")
      let transform = CGAffineTransform(scaleX: 3, y: 3)
      
      if let output = filter.outputImage?.transformed(by: transform) {
        barcodeImage = UIImage(ciImage: output)
        barcodeImageView.image = UIImage(ciImage: output)
        writeToFile(image: barcodeImage!)
      }
    }
  }
  
  @IBAction func shareAction(_ sender: Any) {
    guard let barcodeImage = barcodeImage else { return }
    
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let destinationPath = (documentsPath as NSString).appendingPathComponent("filename.jpg")
    
    let url = URL(fileURLWithPath: destinationPath)
    print(FileManager.default.fileExists(atPath: url.absoluteString))
  }
  
  func writeToFile(image: UIImage) {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let destinationPath = (documentsPath as NSString).appendingPathComponent("filename.jpg")
    
    try? UIImageJPEGRepresentation(image, 1.0)?.write(to: URL(fileURLWithPath: destinationPath), options: .atomic)
  }
}

extension String {
  
  func formatForHRK() -> String {
    let base = self
    let count = base.count
    var formatted = "0000000000000"
    
    let index = formatted.index(formatted.endIndex, offsetBy: -(count))
    formatted.replaceSubrange(index...index, with: base)
    print(formatted)
    return String(formatted)
  }
}
