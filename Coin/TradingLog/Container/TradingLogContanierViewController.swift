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
    @IBOutlet weak var tradingLogStatsView: UIView!
    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segment.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        segment.insertSegment(withTitle: "일별 기록", at: 0, animated: true)
        segment.insertSegment(withTitle: "기간별 기록", at: 1, animated: true)
        
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.middleGrayColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)
        ], for: .normal)
        segment.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.fallColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)
        ], for: .selected)
        
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
            underLineView.heightAnchor.constraint(equalToConstant: 3),
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
