//
//  TradingLogContanierViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/12.
//

import UIKit

class TradingLogContanierViewController: UIViewController, Storyboarded {

    private let tradingLogViewController: UIViewController

    init?(coder: NSCoder,
          tradingLogController: UIViewController) {
        self.tradingLogViewController = tradingLogController
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @IBOutlet weak var tradingLogContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func configure() {
        
        tradingLogViewController.view.frame = tradingLogContainerView.bounds
        tradingLogContainerView.addSubview(tradingLogViewController.view)
        addChild(tradingLogViewController)
        tradingLogViewController.didMove(toParent: self)
    }
}
