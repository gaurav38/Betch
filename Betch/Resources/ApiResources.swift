//
//  ApiResources.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/12/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import Foundation

class ApiResources {
    static let HostUrl: String = "api.coinmarketcap.com"
    static let Apipath: String = "/v1/ticker/"
    static let RequestScheme: String = "https"
    
    struct RequestParams {
        static let Convert: String = "convert"
        static let Limit: String = "limit"
    }
    
    struct ResponseDataParams {
        static let ID = "id"
        static let NAME = "name"
        static let PERCENT_CHANGE_1H = "percent_change_1h"
        static let PERCENT_CHANGE_24H = "percent_change_24h"
        static let PERCENT_CHANGE_7D = "percent_change_7d"
        static let SYMBOL = "symbol"
        
    }
    
    static let CURRENCY_RESPONSE_MAPPING = [
        "USD": "price_usd",
        "AUD": "price_aud",
        "CAD": "price_cad",
        "EUR": "price_eur",
        "GBP": "price_gbp",
        "INR": "price_inr",
        "JPY": "price_jpy",
        "CHF": "price_chf",
        "CNY": "price_cny",
        "BRL": "price_brl",
        "HKD": "price_hkd",
        "IDR": "price_idr",
        "KRW": "price_krw",
        "MXN": "price_mxn",
        "RUB": "price_rub"
    ]
}
