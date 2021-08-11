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
    @IBOutlet weak var dayOfTheWeekLabel: UILabel!
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
        configureDate(from: log.date)
        configureRate(from: log.rate)
        self.startPriceLabel.text = "\(log.startPrice)"
        self.endPriceLabel.text = "\(log.endPrice)"
        self.proceedsLabel.text = "\(log.profit)"
        
    }

    private func configureDate(from: Date?) {
        guard let date = from else { return }
        self.numberOfDaysLabel.text = date.showCurrentDay()
        self.dayOfTheWeekLabel.text = DayOfWeek(rawValue: date.showCurrentDayOfWeek())!.description
    }
    
    private func configureRate(from: Double) {
        let value = String(format: "%.1f", from) + "%"
        self.yieldLabel.text = value
    }
}
