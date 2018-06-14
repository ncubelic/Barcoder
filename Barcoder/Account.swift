//
//  Account.swift
//  Barcoder
//
//  Created by Nikola on 25/05/2018.
//  Copyright © 2018 Ingemark. All rights reserved.
//

import Foundation

class Account: NSObject, NSCoding {
    
    var currency: String
    var payeeName: String
    var payeeAddress: String
    var payeeCity: String
    var payeeIBAN: String
    var paymentModel: String
    var paymentReferenceNumber: String
    var paymentSomething: String
    
    init(currency: String = "", payeeName: String = "", payeeAddress: String = "", payeeCity: String = "", payeeIBAN: String = "", paymentModel: String = "", referenceNumber: String = "", something: String = "") {
        self.currency = currency
        self.payeeName = payeeName
        self.payeeAddress = payeeAddress
        self.payeeCity = payeeCity
        self.payeeIBAN = payeeIBAN
        self.paymentModel = paymentModel
        self.paymentReferenceNumber = referenceNumber
        self.paymentSomething = something
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard
            let currency = decoder.decodeObject(forKey: "currency") as? String,
            let payeeName = decoder.decodeObject(forKey: "payeeName") as? String,
            let payeeAddress = decoder.decodeObject(forKey: "payeeAddress") as? String,
            let payeeCity = decoder.decodeObject(forKey: "payeeCity") as? String,
            let payeeIBAN = decoder.decodeObject(forKey: "payeeIBAN") as? String,
            let paymentModel = decoder.decodeObject(forKey: "paymentModel") as? String,
            let paymentReferenceNumber = decoder.decodeObject(forKey: "paymentReferenceNumber") as? String,
            let paymentSomething = decoder.decodeObject(forKey: "paymentSomething") as? String
            else { return nil }
        
        self.init(currency: currency, payeeName: payeeName, payeeAddress: payeeAddress, payeeCity: payeeCity, payeeIBAN: payeeIBAN, paymentModel: paymentModel, referenceNumber: paymentReferenceNumber, something: paymentSomething)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.currency, forKey: "currency")
        aCoder.encode(self.payeeName, forKey: "payeeName")
        aCoder.encode(self.payeeAddress, forKey: "payeeAddress")
        aCoder.encode(self.payeeCity, forKey: "payeeCity")
        aCoder.encode(self.payeeIBAN, forKey: "payeeIBAN")
        aCoder.encode(self.paymentModel, forKey: "paymentModel")
        aCoder.encode(self.paymentReferenceNumber, forKey: "paymentReferenceNumber")
        aCoder.encode(self.paymentSomething, forKey: "paymentSomething")
    }
}
