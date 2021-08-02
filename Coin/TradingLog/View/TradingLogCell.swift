//
//  TradingLogCell.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/01.
//

import UIKit

class TradingLogCell: UITableViewCell {

    @IBOutlet weak var logStateIView: UIView!
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    @IBOutlet weak var dayOfTheWeekLabel: UIStackView!
    @IBOutlet weak var startPriceLabel: UILabel!
    @IBOutlet weak var endPriceLabel: UILabel!
    @IBOutlet weak var proceedsLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var memoStackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(log: TradingLogMO) {
        
        self.startPriceLabel.text = "\(log.startPrice)"
        self.endPriceLabel.text = "\(log.endPrice)"
        self.proceedsLabel.text = "\(log.profit)"
        self.yieldLabel.text = "\(log.rate)"
    }

}
