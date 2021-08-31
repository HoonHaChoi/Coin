//
//  SearchViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit
import Combine

class SearchViewController: UIViewController, Storyboarded {

    typealias SearchDataSource = TableDataSource<SearchCoinCell, Coin>
    
    private var viewModel: SearchViewModel
    private let searchCoinDataSource: SearchDataSource
    private var cancellable = Set<AnyCancellable>()
    
    var keywordHandler: ((String) -> Void)?
    var fetchFavoriteCoin: (() -> ([String]))?
    var insertFavoriteHandler: ((String) -> Void)?
    var deleteFavoriteHandler: ((String) -> Void)?
    
    init?(coder: NSCoder,
          viewModel: SearchViewModel,
          dataSource: SearchDataSource) {
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
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        coinListTableView.register(cell: SearchCoinCell.self)
        coinListTableView.dataSource = searchCoinDataSource
        searchCoin()
    }
    
    private func searchCoin() {
        searchController.textFieldPublisher.sink { [weak self] keyword in
            self?.keywordHandler?(keyword)
        }.store(in: &cancellable)
    }
        
    lazy var updateSearchResult: (([Coin]) -> ()) = { coinList in
        self.searchCoinDataSource.updateDataSource(from: coinList)
        let findIndex = self.searchCoinDataSource.findIndexes(uuids: self.fetchUUID())
        let indexPaths = self.searchCoinDataSource.makeIndexPath(indexes: findIndex)
        DispatchQueue.main.async { [weak self] in
            self?.coinListTableView.reloadData()
            self?.selectRows(from: indexPaths)
        }
    }
    
    private func selectRows(from indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            coinListTableView.selectRow(at: indexPath,
                                        animated: true,
                                        scrollPosition: .none)
        }
    }
    
    private lazy var fetchUUID: () -> [String] = { [weak self] in
        return self?.fetchFavoriteCoin?() ?? []
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchCoinDataSource.selectModel(index: indexPath.row) { [weak self] uuid in
            self?.insertFavoriteHandler?(uuid)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        searchCoinDataSource.selectModel(index: indexPath.row) { [weak self] uuid in
            self?.deleteFavoriteHandler?(uuid)
        }
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

