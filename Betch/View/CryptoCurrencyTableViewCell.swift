//
//  CryptoCurrencyTableViewCell.swift
//  Betch
//
//  Created by Gaurav Saraf on 8/15/17.
//  Copyright © 2017 Gaurav Saraf. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class CryptoCurrencyTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var currencyName: CurrencyTextField!
    @IBOutlet weak var currencyPrice: CurrencyTextField!
    @IBOutlet weak var currencyPriceChange: UITextField!
    @IBOutlet weak var currencyChangeImageView: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var favoriteIndicator: UIImageView!
    
    var currencySymbol: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 10.0
        currencyName.isUserInteractionEnabled = false
        currencyPrice.isUserInteractionEnabled = false
        currencyPriceChange.isUserInteractionEnabled = false
        favoriteIndicator.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
