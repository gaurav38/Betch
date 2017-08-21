//
//  CountryCode.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/17/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import Foundation

class CountryCode {
    
    private static let defaultCurrency = "USD"
    private static let supportedCurrencies = ["AUD",
                                              "BRL",
                                              "CAD",
                                              "CHF",
                                              "CNY",
                                              "EUR",
                                              "GBP",
                                              "HKD",
                                              "IDR",
                                              "INR",
                                              "JPY",
                                              "KRW",
                                              "MXN",
                                              "RUB"]
    
    public static var currency: String?
    public static var currencySymbol: String?
    
    public static func getCurrency() -> Currency {
        let localeCurrencyCode = NSLocale.current.currencyCode
        let localeCurrencySymbol = NSLocale.current.currencySymbol
        
        if supportedCurrencies.contains(localeCurrencyCode!) {
            currency = localeCurrencyCode
            currencySymbol = localeCurrencySymbol
        } else {
            currency = defaultCurrency
            currencySymbol = "$"
        }
        return Currency(currency!, currencySymbol!)
    }
}

struct Currency {
    let name: String!
    let symbol: String!
    
    init(_ name: String, _ symbol: String) {
        self.name = name
        self.symbol = symbol
    }
}
