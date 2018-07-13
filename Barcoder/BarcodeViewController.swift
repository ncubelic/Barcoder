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
    
    guard
        let data = UserDefaults.standard.object(forKey: "account") as? Data,
        let account = NSKeyedUnarchiver.unarchiveObject(with: data) as? Account
        else {
            navigationController?.popViewController(animated: true)
            return
        }
    
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
      }
    }
  }
  
  @IBAction func shareAction(_ sender: Any) {
    guard
        let barcodeImage = barcodeImage,
        let barcodeCIImage = barcodeImage.ciImage
        else { return }

    let ciContext = CIContext()
    guard let cgImage = ciContext.createCGImage(barcodeCIImage, from: barcodeCIImage.extent) else { return }

    let barcodeUIImage = UIImage(cgImage: cgImage)
    
    // text to share
    let text = "Slikaj i plati:"
    
    // set up activity view controller
    let objectsToShare: [Any] = [barcodeUIImage, text]
    let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
    
    
    // present the view controller
    self.present(activityViewController, animated: true, completion: nil)
  }
  
  func writeToFile(image: UIImage) {
    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let destinationPath = (documentsPath as NSString).appendingPathComponent("filename.jpg")
    
    try? image.jpegData(compressionQuality: 1.0)?.write(to: URL(fileURLWithPath: destinationPath), options: .atomic)
  }
}

extension String {
  
  func formatForHRK() -> String {
    let base = self
    let count = base.count
    let formattedNumbersCount = 15
    var formatterdString = ""
    
    repeat {
      formatterdString.append("0")
    } while formatterdString.count < formattedNumbersCount - count
    
    formatterdString.append(base)
    
    return String(formatterdString)
  }
}
