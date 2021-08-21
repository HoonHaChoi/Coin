//
//  MainContainerViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/22.
//

import UIKit

class MainContainerViewController: UIViewController {
    
    private let pageViews: [UIViewController]
    
    init(viewControllers: [UIViewController]) {
        self.pageViews = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var segmentContainerView: SegmentContainerView = {
        let segmentContainerView = SegmentContainerView()
        segmentContainerView.translatesAutoresizingMaskIntoConstraints = false
        return segmentContainerView
    }()
    
    private var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()
    
    private var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.addSubview(segmentContainerView)
        view.addSubview(searchButton)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
                
        NSLayoutConstraint.activate([
            segmentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            segmentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.centerXAnchor.constraint(equalTo: segmentContainerView.centerXAnchor),
        
            pageViewController.view.topAnchor.constraint(equalTo: segmentContainerView.bottomAnchor, constant: 20),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        pageViewController.didMove(toParent: self)
    }
    
    private func setupPageViewController() {
        guard let pageFirst = pageViews.first else {
            return
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([pageFirst], direction: .forward, animated: true, completion: nil)
    }
}
