//
//  SearchViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit
import Combine

class SearchViewController: UIViewController, Storyboarded {

    private var viewModel: SearchViewModel
    private let searchCoinDataSource: SearchCoinDataSource
    private var cancellable = Set<AnyCancellable>()
    
    var keywordHandler: ((String) -> Void)?
    var removeHandler: (() -> Void)?
    
    init?(coder: NSCoder,
          viewModel: SearchViewModel,
          dataSource: SearchCoinDataSource) {
        self.viewModel = viewModel
        self.searchCoinDataSource = dataSource
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @IBOutlet weak var coinListTableView: UITableView!
    private let searchController: UISearchController = {
        var search = UISearchController()
        search.searchBar.placeholder = "코인명, 심볼명을 입력 해주세요"
        search.obscuresBackgroundDuringPresentation = false
        // 검색 segment 추가 예정
        //search.searchBar.scopeButtonTitles
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        coinListTableView.register(cell: SearchCoinCell.self)
        coinListTableView.dataSource = searchCoinDataSource
        searchCoin()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeHandler?()
    }
    
    private func searchCoin() {
        searchController.textFieldPublisher.sink { [weak self] keyword in
            self?.keywordHandler?(keyword)
        }.store(in: &cancellable)
    }
    
    lazy var updateSearchResult: (([Coin]) -> ()) = { [weak self] coinList in
        DispatchQueue.main.async { [weak self] in
            self?.searchCoinDataSource.updateDataSource(from: coinList)
            self?.coinListTableView.reloadData()
        }
    }
}
