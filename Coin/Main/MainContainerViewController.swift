//
//  MainContainerViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/08/22.
//

import UIKit

class MainContainerViewController: UIViewController {
    
    private var currentPageIndex = 0
    private let pageViews: [UIViewController]
    
    init(viewControllers: [UIViewController]) {
        self.pageViews = viewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var segmentContainerView: SegmentContainerView = {
        let segmentContainerView = SegmentContainerView()
        segmentContainerView.delegate = self
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
        view.backgroundColor = .systemBackground
        configureUI()
        setupPageViewController()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureUI() {
        view.addSubview(segmentContainerView)
        view.addSubview(searchButton)
        view.addSubview(pageViewController.view)

        NSLayoutConstraint.activate([
            segmentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            segmentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            segmentContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55),
            segmentContainerView.heightAnchor.constraint(equalToConstant: 40)
,
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchButton.centerYAnchor.constraint(equalTo: segmentContainerView.centerYAnchor),
        
            pageViewController.view.topAnchor.constraint(equalTo: segmentContainerView.bottomAnchor, constant: 20),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupPageViewController() {
        guard let pageFirst = pageViews.first else {
            return
        }
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        setPageViewController(controller: [pageFirst], direction: .forward)
    }
    
    private func setPageViewController(controller: [UIViewController], direction: UIPageViewController.NavigationDirection) {
        pageViewController.setViewControllers(controller, direction: direction, animated: true, completion: nil)
    }
}

extension MainContainerViewController: SegmentDelegate {
    func didSelectSegmentIndex(to index: Int) {
        index > currentPageIndex ?
            setPageViewController(controller: [pageViews[index]], direction: .forward) :
            setPageViewController(controller: [pageViews[index]], direction: .reverse)
    }
}

extension MainContainerViewController: UIPageViewControllerDelegate,UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageViews.firstIndex(of: viewController) else {
            return nil
        }
        if index == 0 {
            return nil
        }
        let previous = index-1
        return pageViews[previous]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageViews.firstIndex(of: viewController) else {
            return nil
        }
        if index == pageViews.count-1 {
            return nil
        }
        let next = index+1
        return pageViews[next]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = pageViews.firstIndex(of: viewController) else {
            return
        }
        currentPageIndex = index
        segmentContainerView.updateSelectIndex(to: index)
    }
}
