//
//  TradingLogContanierViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/12.
//

import UIKit

class TradingLogContanierViewController: UIViewController, Storyboarded {

    private let tradingLogViewController: UIViewController
    private let tradingLogStatsViewController: UIViewController
    init?(coder: NSCoder,
          tradingLogController: UIViewController,
          tradingLogStatsController: UIViewController) {
        self.tradingLogViewController = tradingLogController
        self.tradingLogStatsViewController = tradingLogStatsController
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var tradingLogScrollView: UIScrollView!
    @IBOutlet weak var tradingLogContainerView: UIView!
    @IBOutlet weak var tradingLogStatsContainerView: UIView!
    private lazy var segmentControl: PageSegmentControl = {
        let segment = PageSegmentControl(items: ["일별 기록", "기간별 기록"])
        segment.addTarget(self, action: #selector(changeSegmentedControlLinePosition), for: .valueChanged)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private lazy var underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .fallColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        return view
    }()
    
    private lazy var leadingDistance: NSLayoutConstraint = {
        return underLineView.leadingAnchor.constraint(equalTo: segmentControl.leadingAnchor)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerViewConfigure()
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
        
        tradingLogStatsViewController.view.frame = tradingLogStatsContainerView.bounds
        tradingLogStatsContainerView.addSubview(tradingLogStatsViewController.view)
        addChild(tradingLogStatsViewController)
        tradingLogStatsViewController.didMove(toParent: self)
    }
    
    private func headerViewConfigure() {
        
        topContainerView.addSubview(segmentControl)
        topContainerView.addSubview(underLineView)
        
        NSLayoutConstraint.activate([
            segmentControl.topAnchor.constraint(equalTo: topContainerView.topAnchor),
            segmentControl.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            segmentControl.centerYAnchor.constraint(equalTo: topContainerView.centerYAnchor),
            segmentControl.centerXAnchor.constraint(equalTo: topContainerView.centerXAnchor),

            underLineView.bottomAnchor.constraint(equalTo: segmentControl.bottomAnchor),
            underLineView.heightAnchor.constraint(equalToConstant: 5),
            leadingDistance,
            underLineView.widthAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 1 / CGFloat(segmentControl.numberOfSegments))
        ])
    }
    
    @objc private func changeSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(segmentControl.selectedSegmentIndex)
        let segmentWidth = segmentControl.frame.width / CGFloat(segmentControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.leadingDistance.constant = leadingDistance
            self?.tradingLogScrollView.contentOffset.x = self?.tradingLogScrollView.contentOffset.x == 0 ?
                (self?.view.frame.width ?? 0) : 0
            self?.view.layoutIfNeeded()
        })
    }
}
