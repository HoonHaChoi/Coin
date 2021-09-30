//
//  DetailViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/06.
//

import UIKit

class DetailViewController: UIViewController {
    
    private let starImage = "starsmall"
    private let starImageFill = "starsmallfill"
    
    private let coin: Coin
    private let imageLoader: Loader
    
    init(coin: Coin, imageLoader: Loader){
        self.coin = coin
        self.imageLoader = imageLoader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: starImage), for: .normal)
        button.setImage(UIImage(named: starImageFill), for: .selected)
        button.addTarget(self,
                         action: #selector(didFavoriteTapped(_:)),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var infoView: DetailInfoView = {
        let view = DetailInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let chartWebView: DetailChartView = {
        let chartView = DetailChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    var coinFindHandler: ((String) -> Bool)?
    var favoriteButtonAction: ((String) -> ())?
    var requestJoinEvent: ((String) -> ())?
    var requestLeaveEvent: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        self.title = coin.ticker
        configureFavoriteButton()
        configureUI()
        loadChartView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestJoinEvent?(coin.uuid)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        requestLeaveEvent?(coin.uuid)
    }
    
    private func configureUI() {
        view.addSubview(infoView)
        view.addSubview(chartWebView)
        
        NSLayoutConstraint.activate([
            infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.heightAnchor.constraint(equalToConstant: 55),
            
            chartWebView.topAnchor.constraint(equalTo: infoView.bottomAnchor),
            chartWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chartWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chartWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        infoView.configure(coin: coin, imageLoader: imageLoader)
    }
    
    private func loadChartView() {
        chartWebView.configure(url: Endpoint.chartURL(uuid: coin.uuid))
    }
 
    private func configureFavoriteButton() {
        guard let isSelectedState = coinFindHandler?(coin.uuid) else {
            return
        }
        favoriteButton.isSelected = isSelectedState
        favoriteButton.tintColor = isSelectedState ? .riseColor : .basicColor
    }
    
    @objc func didFavoriteTapped(_ sender: UIButton) {
        favoriteButtonAction?(coin.uuid)
        favoriteButton.isSelected = !favoriteButton.isSelected
        favoriteButton.tintColor = favoriteButton.isSelected ? .riseColor : .basicColor
    }
    
    lazy var updateInfoUI: (([CoinMeta]) -> ()) = { [weak self] meta in
        meta.forEach { [weak self] coinMeta in
            self?.infoView.updateUI(coin: coinMeta)
        }
    }
    
    lazy var showError: (NetworkError) -> () = { [weak self] error in
        let alert = UIAlertController(title: "에러", message: error.description)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    deinit {
        print(#function)
    }
}
