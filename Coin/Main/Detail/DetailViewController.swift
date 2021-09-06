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
    
    init(coin: Coin){
        self.coin = coin
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
    
    var coinFindHandler: ((String) -> Bool)?
    var favoriteButtonAction: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
        configureFavoriteButton()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(infoView)
        infoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        infoView.heightAnchor.constraint(equalToConstant: 35).isActive = true
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
    }
    
    deinit {
        print(#function)
    }
}
