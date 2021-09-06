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
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: starImage), for: .normal)
        button.setImage(UIImage(named: starImageFill), for: .selected)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteButton)
    }
 
    deinit {
        print(#function)
    }
}
