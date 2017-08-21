//
//  CryptoCurrenciesViewModelProtocol.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/14/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import Foundation

protocol CryptoCurrenciesViewModelProtocol {
    var service: CoinMarketCapService! { get }
    var cryptoCurrencies: [CryptoCurrency]! { get set }
    func fetchCryptoCurrencies()
    var cryptoCurrenciesChanged: ((CryptoCurrenciesViewModelProtocol) -> ())? { get set }
    var favorites: [String]! { get }
    
    init(service: CoinMarketCapService)
    func addFavorite(currency: String)
    func removeFavorite(currency: String)
}
