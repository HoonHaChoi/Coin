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
    
    var keywordHandler: ((String,String) -> Void)?
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
    private let allTitle = "All"
    private lazy var searchController: UISearchController = {
        var search = UISearchController()
        search.searchBar.placeholder = "코인명(영문), 심볼명을 입력 해주세요"
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.scopeButtonTitles = [allTitle]+Exchange.allCases.map { $0.toString.capitalized }
        search.searchBar.delegate = self
        return search
    }()
    
    private let loadingView: LoadingView = {
        let loadview = LoadingView()
        loadview.translatesAutoresizingMaskIntoConstraints = false
        loadview.isHidden = true
        return loadview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        coinListTableView.register(cell: SearchCoinCell.self)
        coinListTableView.dataSource = searchCoinDataSource
        coinListTableView.tableFooterView = UIView()
        loadingViewConfigure()
        searchCoin()
    }
    
    private func searchCoin() {
        let searchBar = searchController.searchBar
        searchController.textFieldPublisher.sink { [weak self] keyword in
            guard let scopeExchangeTitle = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else {
                return
            }
            
            self?.keywordHandler?(keyword,
                                  self?.adjustScopeTitle(scope: scopeExchangeTitle) ?? "")
        }.store(in: &cancellable)
    }
        
    private func loadingViewConfigure() {
        view.addSubview(loadingView)
    
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    lazy var loadingHiddenState: ((Bool) -> ()) = { [weak self] state in
        DispatchQueue.main.async {
            self?.loadingView.isHidden = state
        }
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
    
    private func adjustScopeTitle(scope: String) -> String {
        scope == allTitle ? "" : scope
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        guard let keyword = searchBar.text,
              let scope = searchBar.scopeButtonTitles?[selectedScope] else {
            return
        }
        keywordHandler?(keyword, adjustScopeTitle(scope: scope))
    }
}
