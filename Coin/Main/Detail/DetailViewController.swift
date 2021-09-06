//
//  DetailViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/09/06.
//

import UIKit

class DetailViewController: UIViewController {

    private let favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "starsmall"), style: .plain, target: self, action: nil)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    
}
