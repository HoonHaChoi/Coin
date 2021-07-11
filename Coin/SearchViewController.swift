//
//  SearchViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit

class SearchViewController: UIViewController, Storyboarded {

    private var vm = SearchViewModel()
    
    @IBOutlet weak var coinListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.fetchSearchCoins()
    }

    
}
