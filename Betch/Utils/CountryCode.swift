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
    public static let supportedCurrencies = ["AUD", "BRL", "CAD", "CHF", "CLP", "CNY", "CZK", "DKK", "EUR", "GBP", "HKD", "HUF", "IDR", "ILS", "INR", "JPY", "KRW", "MXN", "MYR", "NOK", "NZD", "PHP", "PKR", "PLN", "RUB", "SEK", "SGD", "THB", "TRY", "TWD", "USD", "ZAR"]
    
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
    
    public static func getCurrency(currencyCode: String) -> Currency {
        currency = currencyCode
        
        let locale = Locale
            .availableIdentifiers
            .map { Locale(identifier: $0) }
            .first { $0.currencyCode == currencyCode }
        currencySymbol = locale?.currencySymbol ?? currencyCode
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
