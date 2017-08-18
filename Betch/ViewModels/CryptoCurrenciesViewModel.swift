//
//  CryptoCurrenciesViewModel.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/14/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import Foundation

class CryptoCurrenciesViewModel: CryptoCurrenciesViewModelProtocol {
    var service: CoinMarketCapService!
    var cryptoCurrencies: [CryptoCurrency]! {
        didSet {
            self.cryptoCurrenciesChanged?(self)
        }
    }
    
    var cryptoCurrenciesChanged: ((CryptoCurrenciesViewModelProtocol) -> ())?
    
    func fetchCryptoCurrencies() {
        service.CreateAndStartApiRequest() { cryptoCurrencies in
            DispatchQueue.main.async {
                self.cryptoCurrencies = cryptoCurrencies
            }
        }
    }
    
    required init(service: CoinMarketCapService) {
        self.service = service
        cryptoCurrencies = [CryptoCurrency]()
    }
}
