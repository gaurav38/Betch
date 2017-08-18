//
//  CryptoCurrency.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/14/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import Foundation

class CryptoCurrency {
    private(set) var id: String!
    private(set) var name: String!
    private(set) var percent_change_1h: String!
    private(set) var percent_change_24h: String!
    private(set) var percent_change_7d: String!
    private(set) var price: String!
    private(set) var currency: String!
    private(set) var symbol: String!
    
    init(_ data: [String: AnyObject], for currency: String) {
        if let id = data[ApiResources.ResponseDataParams.ID] {
            self.id = id as! String
        }
        if let name = data[ApiResources.ResponseDataParams.NAME] {
            self.name = name as! String
        }
        if let percent_change_1h = data[ApiResources.ResponseDataParams.PERCENT_CHANGE_1H] {
            self.percent_change_1h = percent_change_1h as! String
        }
        if let percent_change_24h = data[ApiResources.ResponseDataParams.PERCENT_CHANGE_24H] {
            self.percent_change_24h = percent_change_24h as! String
        }
        if let percent_change_7d = data[ApiResources.ResponseDataParams.PERCENT_CHANGE_7D] {
            self.percent_change_7d = percent_change_7d as! String
        }
        self.currency = currency
        if let symbol = data[ApiResources.ResponseDataParams.SYMBOL] {
            self.symbol = symbol as! String
        }
        if let price = data[ApiResources.CURRENCY_RESPONSE_MAPPING[currency]!] {
            self.price = price as! String
        }
    }
}
