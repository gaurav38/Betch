//
//  CoinMarketCapService.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/12/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import Foundation

class CoinMarketCapService {
    private var currentApiTask: ApiTask? = nil
    private var currency: String!
    private var coinsLimit: Int!
    private var requestInterval: Int!
    
    init() {
        self.coinsLimit = ApiConfiguration.coinsLimit
        self.requestInterval = ApiConfiguration.requestInterval
    }
    
    private func reset() {
        self.currency = ApiConfiguration.defaultCurrency
    }
    
    public func CreateAndStartApiRequest(_ callBack: @escaping (_ data: [CryptoCurrency]) -> Void) {
        currentApiTask?.stop()
        currentApiTask = nil
        reset()
        
        let params = [
            "\(ApiResources.RequestParams.Limit)": coinsLimit,
            "\(ApiResources.RequestParams.Convert)": currency
        ] as [String: AnyObject]
        
        let requestUrl = getURLFromParameters(parameters: params, withPathExtension: nil)
        print(requestUrl)
        let request = URLRequest(url: requestUrl)
        
        currentApiTask = ApiTask(request, requestInterval) { data in
            if let data = data {
                callBack(self.parseJSON(from: data, for: self.currency))
            }
        }
        
        currentApiTask?.start()
    }
    
    private func parseJSON(from data: AnyObject, for currency: String) -> [CryptoCurrency] {
        var cryptoCurrencies = [CryptoCurrency]()
        if let cryptoCurrencyJson = data as? [[String: AnyObject]] {
            for cryptoCurrency in cryptoCurrencyJson {
                cryptoCurrencies.append(CryptoCurrency(cryptoCurrency, for: currency))
            }
        }
        return cryptoCurrencies
    }
    
    private func getURLFromParameters(parameters: [String: AnyObject], withPathExtension: String?) -> URL {
        var components = URLComponents()
        components.scheme = ApiResources.RequestScheme
        components.host = ApiResources.HostUrl
        components.path = ApiResources.Apipath
        
        if !parameters.isEmpty {
            components.queryItems = [URLQueryItem]()
            
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems?.append(queryItem)
            }
        }
        return components.url!
    }
}
