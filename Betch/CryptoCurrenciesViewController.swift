//
//  ViewController.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/12/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class CryptoCurrenciesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? [String]()
    fileprivate var viewModel: CryptoCurrenciesViewModelProtocol? {
        didSet {
            self.viewModel?.cryptoCurrenciesChanged = { [unowned self] viewModel in
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModel = appDelegate.container.resolve(CryptoCurrenciesViewModelProtocol.self)
        viewModel?.fetchCryptoCurrencies()
    }
}

extension CryptoCurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.cryptoCurrencies.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CryptoCurrencyTableViewCell", owner: self, options: nil)?.first as! CryptoCurrencyTableViewCell
        let currency = (viewModel?.cryptoCurrencies[indexPath.row])!
        cell.currencyName.text = "\(currency.symbol!) (\(currency.name!))"
        cell.currencyPrice.text = "\(appDelegate.currencySymbol!)\(currency.price!)"
        cell.currencyPriceChange.text = "\(currency.percent_change_24h!)%"
        cell.currencyChangePeriod.text = "24 hours"
        if (currency.percent_change_24h as NSString).floatValue < 0 {
            cell.currencyChangeImageView.image = #imageLiteral(resourceName: "DownArrow")
        } else {
            cell.currencyChangeImageView.image = #imageLiteral(resourceName: "UpArrow")
        }
        if (currency.isFavorite ?? false) {
            cell.favoriteIndicator.isHidden = false
        }
        
        cell.currencySymbol = currency.symbol!
        
        if let favorited = currency.isFavorite, favorited {
            let unFavoriteButton = MGSwipeButton(title: "UnFavorite", icon: #imageLiteral(resourceName: "Unfavorite"), backgroundColor: .white) {
                (sender: MGSwipeTableCell!) -> Bool in
                if let cell = sender as? CryptoCurrencyTableViewCell {
                    self.viewModel?.removeFavorite(currency: cell.currencySymbol!)
                }
                return true
            }
            cell.leftButtons = [unFavoriteButton]
        } else {
            let favoriteButton = MGSwipeButton(title: "Favorite", icon: #imageLiteral(resourceName: "Favorite"), backgroundColor: .white) {
                (sender: MGSwipeTableCell!) -> Bool in
                if let cell = sender as? CryptoCurrencyTableViewCell {
                    self.viewModel?.addFavorite(currency: cell.currencySymbol!)
                }
                return true
            }
            cell.leftButtons = [favoriteButton]
        }
        
        cell.leftSwipeSettings.transition = .border
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

