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
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var change1HourButton: UIButton!
    @IBOutlet weak var change24HoursButton: UIButton!
    @IBOutlet weak var change7DaysButton: UIButton!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var currencyTableView: UITableView!
    @IBOutlet weak var currencyChangeView: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var offlineErrorView: UIView!
    
    var favorites = UserDefaults.standard.array(forKey: "favorites") as? [String] ?? [String]()
    fileprivate var changeDuration = ChangeDuration.OneDay
    fileprivate var appDelegate = UIApplication.shared.delegate as! AppDelegate
    fileprivate var viewModel: CryptoCurrenciesViewModelProtocol? {
        didSet {
            self.viewModel?.cryptoCurrenciesChanged = { [unowned self] viewModel in
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            }
        }
    }
    fileprivate var localCurrency: Currency! {
        return appDelegate.localCurrency!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeView()
        tableView.register(UINib(nibName: "CryptoCurrencyTableViewCell", bundle: nil), forCellReuseIdentifier: "CryptoCurrencyTableViewCell")
        currencyTextField.text = localCurrency.name!
        NotificationCenter.default.addObserver(self, selector: #selector(statusManager), name: .flagsChanged, object: Network.reachability)
        viewModel = appDelegate.container.resolve(CryptoCurrenciesViewModelProtocol.self)
        if isNetworkAvailable() {
            viewModel?.fetchCryptoCurrencies()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func initializeView() {
        buttonsView.layer.borderWidth = 1.0
        buttonsView.layer.cornerRadius = 5.0
        buttonsView.layer.borderColor = Colors.HEADER_BLUE.cgColor
        change1HourButton.setTitleColor(UIColor.white, for: .selected)
        change24HoursButton.setTitleColor(UIColor.white, for: .selected)
        change7DaysButton.setTitleColor(UIColor.white, for: .selected)
        change24HoursButton.isSelected = true
        currencyChangeView.isHidden = true
        if isNetworkAvailable() {
            offlineErrorView.isHidden = true
            loadingView.isHidden = false
        } else {
            offlineErrorView.isHidden = false
            loadingView.isHidden = true
        }
        tableView.delegate = self
        tableView.dataSource = self
        currencyTextField.delegate = self
        currencyTableView.delegate = self
        currencyTableView.dataSource = self
    }
    
    @IBAction func change1Hour(_ sender: Any) {
        changeDuration = ChangeDuration.OneHour
        change1HourButton.isSelected = true
        change24HoursButton.isSelected = false
        change7DaysButton.isSelected = false
        self.tableView.reloadData()
    }
    
    @IBAction func change24Hours(_ sender: Any) {
        changeDuration = ChangeDuration.OneDay
        change1HourButton.isSelected = false
        change24HoursButton.isSelected = true
        change7DaysButton.isSelected = false
        self.tableView.reloadData()
    }
    
    @IBAction func change7Days(_ sender: Any) {
        changeDuration = ChangeDuration.SevenDays
        change1HourButton.isSelected = false
        change24HoursButton.isSelected = false
        change7DaysButton.isSelected = true
        self.tableView.reloadData()
    }
    
    func statusManager(_ notification: NSNotification) {
        if isNetworkAvailable() {
            offlineErrorView.isHidden = true
            viewModel?.fetchCryptoCurrencies()
            if viewModel?.cryptoCurrencies.count == 0 {
                loadingView.isHidden = false
            }
        } else {
            offlineErrorView.isHidden = false
        }
    }
    
    private func isNetworkAvailable() -> Bool {
        guard let status = Network.reachability?.status else { return false }
        switch status {
        case .unreachable:
            return false
        case .wifi, .wwan:
            return true
        }
    }
}

extension CryptoCurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return (viewModel?.cryptoCurrencies.count)!
        } else if tableView == currencyTableView {
            return CountryCode.supportedCurrencies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCurrencyTableViewCell", for: indexPath) as! CryptoCurrencyTableViewCell
            resetCell(cell: cell)
            
            let currency = (viewModel?.cryptoCurrencies[indexPath.row])!
            let formattedPrice = String(format:"%.4f", (currency.price! as NSString).floatValue)
            cell.currencyName.text = "\(currency.symbol!) (\(currency.name!))"
            cell.currencyPrice.text = "\(localCurrency.symbol!)\(formattedPrice)"
            cell.currencySymbol = currency.symbol!
            
            var priceChange: Float = 0.0
            switch changeDuration {
            case .OneHour:
                priceChange = (currency.percent_change_1h as NSString).floatValue
            case .OneDay:
                priceChange = (currency.percent_change_24h as NSString).floatValue
            case .SevenDays:
                priceChange = (currency.percent_change_7d as NSString).floatValue
            }
            
            cell.currencyPriceChange.text = "\(priceChange)%"
            
            if priceChange < 0 {
                cell.currencyChangeImageView.image = #imageLiteral(resourceName: "DownArrow")
            } else {
                cell.currencyChangeImageView.image = #imageLiteral(resourceName: "UpArrow")
            }
            if (currency.isFavorite ?? false) {
                cell.favoriteIndicator.isHidden = false
            }
            
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
            
            cell.leftSwipeSettings.transition = .rotate3D
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell")!
            cell.textLabel?.text = CountryCode.supportedCurrencies[indexPath.row]
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            return 110
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tableView == self.tableView {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            return
        } else {
            self.currencyTextField.text = CountryCode.supportedCurrencies[indexPath.row]
            ApiConfiguration.defaultCurrency = CountryCode.supportedCurrencies[indexPath.row]
            appDelegate.localCurrency = CountryCode.getCurrency(currencyCode: CountryCode.supportedCurrencies[indexPath.row])
            self.viewModel?.fetchCryptoCurrencies()
            self.currencyChangeView.isHidden = true
        }
    }
    
    private func resetCell(cell: CryptoCurrencyTableViewCell) {
        cell.currencyName.text = ""
        cell.currencyPrice.text = ""
        cell.currencyPriceChange.text = ""
        cell.favoriteIndicator.isHidden = true
        cell.currencySymbol = localCurrency.name
    }
}

extension CryptoCurrenciesViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //let image = UIImage(fromView: self.view)?.applyDarkEffect()
        //self.currencyChangeView.backgroundColor = UIColor(patternImage: image!)
        self.currencyChangeView.isHidden = false
        return false
    }
}

