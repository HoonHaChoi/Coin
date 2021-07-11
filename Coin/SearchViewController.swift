//
//  SearchViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit
import Combine

class SearchViewController: UIViewController, Storyboarded {

    private var vm = SearchViewModel()
    private let searchCoinDataSource = SearchCoinDataSource()
    private var cancellable = Set<AnyCancellable>()
    
    @IBOutlet weak var coinListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinListTableView.register(cell: SearchCoinCell.self)
        coinListTableView.dataSource = searchCoinDataSource
        update()
        bind()
    }

    func update() {
        vm.fetchSearchCoins()
    }
    
    func bind() {
        vm.$coins
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.searchCoinDataSource.updateDataSource(from: coins)
                self?.coinListTableView.reloadData()
        }.store(in: &cancellable)
    }
}
