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
    var favorites : [String]!
    var cryptoCurrencies: [CryptoCurrency]! {
        didSet {
            self.cryptoCurrenciesChanged?(self)
        }
    }
    
    var cryptoCurrenciesChanged: ((CryptoCurrenciesViewModelProtocol) -> ())?
    
    func fetchCryptoCurrencies() {
        service.CreateAndStartApiRequest() { cryptoCurrencies in
            DispatchQueue.main.async {
                self.cryptoCurrencies = self.applyFavoriteSortOrder(cryptoCurrencies)
            }
        }
    }
    
    required init(service: CoinMarketCapService) {
        self.service = service
        cryptoCurrencies = [CryptoCurrency]()
        favorites = UserDefaults.standard.object(forKey: "favorites") as? [String] ?? [String]()
    }
    
    func addFavorite(currency: String) {
        favorites.append(currency)
        UserDefaults.standard.set(favorites, forKey: "favorites")
        favorites = UserDefaults.standard.object(forKey: "favorites") as! [String]
        let favorited = self.cryptoCurrencies.first(where: { $0.symbol == currency })
        favorited?.isFavorite = true
        self.cryptoCurrencies = applyFavoriteSortOrder(self.cryptoCurrencies)
    }
    
    func removeFavorite(currency: String) {
        favorites = favorites.filter { $0 != currency }
        UserDefaults.standard.set(favorites, forKey: "favorites")
        favorites = UserDefaults.standard.object(forKey: "favorites") as! [String]
        let unFavorited = self.cryptoCurrencies.first(where: { $0.symbol == currency })
        unFavorited?.isFavorite = false
        self.cryptoCurrencies = applyFavoriteSortOrder(self.cryptoCurrencies)
    }
    
    private func applyFavoriteSortOrder(_ cryptoCurrencies: [CryptoCurrency]) -> [CryptoCurrency] {
        if favorites.count == 0 {
            return cryptoCurrencies
        } else {
            var favoriteList = [CryptoCurrency]()
            var nonFavoritieList = [CryptoCurrency]()
            for crypto in cryptoCurrencies {
                if let _ = self.favorites.first(where: { $0 == crypto.symbol }) {
                    crypto.isFavorite = true
                    favoriteList.append(crypto)
                } else {
                    crypto.isFavorite = false
                    nonFavoritieList.append(crypto)
                }
            }
            return favoriteList + nonFavoritieList
        }
    }
}
