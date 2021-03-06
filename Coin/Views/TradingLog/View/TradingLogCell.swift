//
//  TradingLogCell.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/01.
//

import UIKit

class TradingLogCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var logStateView: UIView!
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
        backView.backgroundColor = .basicBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let view = UIView()
        view.backgroundColor = .clear
        self.selectedBackgroundView = view
    }
    
    func configure(log: TradingLogMO) {
        configureDate(from: log.date)
        configureRate(from: log.rate)
        configureMemo(from: log.memo)
        setColor(from: log.marketState)
        makeLogStateViewCorner()
        self.startPriceLabel.text = log.startPrice.convertPriceKRW()
        self.endPriceLabel.text = log.endPrice.convertPriceKRW()
        self.proceedsLabel.text = log.profit.convertPriceKRW()
    }

    private func configureDate(from: Date?) {
        guard let date = from else { return }
        self.numberOfDaysLabel.text = date.showCurrentDay()
        self.dayOfTheWeekLabel.text = DayOfWeek(rawValue: date.showCurrentDayOfWeek())!.description
    }
    
    private func configureRate(from yield: Double) {
        self.yieldLabel.text = String(format: "%.1f", yield)+"%"
    }
    
    private func configureMemo(from: String?) {
        guard let memo = from, !(memo.isEmpty) else {
            memoStackView.isHidden = true
            return
        }
        memoStackView.isHidden = false
        memoLabel.text = memo
    }
    
    private func setColor(from markState: String?) {
        guard let stateString = markState else { return }
        let state = Change.selectType(stateString)
        switch state {
        case .rise:
            changeColor(stateColor: .riseColor,
                        proceedsColor: .riseColor,
                        yieldColor: .riseColor)
        case .fall:
            changeColor(stateColor: .fallColor,
                        proceedsColor: .fallColor,
                        yieldColor: .fallColor)
        case .even:
            changeColor()
        }
        
        func changeColor(stateColor: UIColor = .weakGrayColor,
                         proceedsColor: UIColor = .basicColor,
                         yieldColor: UIColor = .basicColor) {
            logStateView.backgroundColor = stateColor
            proceedsLabel.textColor = proceedsColor
            yieldLabel.textColor = yieldColor
        }
    }
    
    private func makeLogStateViewCorner() {
        logStateView.layer.cornerRadius = 10
        logStateView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
        backView.layer.cornerRadius = 10
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        backView.layer.shadowOpacity = 0.2
        backView.layer.shadowRadius = 4.0
      }

    override func prepareForReuse() {
        memoStackView.isHidden = false
    }
}
