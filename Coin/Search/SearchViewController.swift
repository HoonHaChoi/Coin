//
//  SearchViewController.swift
//  Coin
//
//  Created by HOONHA CHOI on 2021/07/11.
//

import UIKit
import Combine

enum SearchStyle {
    case favorite
    case notification
}

class SearchViewController: UIViewController, Storyboarded {
    
    private let imageLoader: Loader
    private let searchCoinDataSource: SearchTableDataSource
    private var cancellable = Set<AnyCancellable>()
    
    var keywordHandler: ((String,String) -> Void)?
    var fetchFavoriteCoin: (() -> ([String]))?
    var updateFavoriteHandler: ((String) -> Void)?
    
    private var searchStyle: SearchStyle
    weak var coordinator: SearchCoordinator?
    
    init?(coder: NSCoder,
          imageLoader: Loader,
          dataSource: SearchTableDataSource,
          style: SearchStyle) {
        self.imageLoader = imageLoader
        self.searchStyle = style
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
        keywordHandler?("", "")
    }
    
    private func searchCoin() {
        let searchBar = searchController.searchBar
        searchController.textFieldPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] keyword in
            
            guard let self = self,
                  let scopeExchangeTitle = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] else {
                return
            }
            
            self.keywordHandler?(keyword,
                                 self.adjustScopeTitle(scope: scopeExchangeTitle))
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
    
    lazy var updateSearchResult: (([Coin]) -> ()) = { [weak self] coinList in
        self?.searchCoinDataSource.updateDataSource(from: coinList)
        let findExistentUUIDIndex = self?.searchCoinDataSource.findIndexes(uuids: self?.fetchUUID() ?? [])
        self?.searchCoinDataSource.updateState(from: findExistentUUIDIndex ?? [])
        DispatchQueue.main.async {
            self?.coinListTableView.reloadData()
        }
    }
    
    private lazy var fetchUUID: () -> [String] = { [weak self] in
        return self?.fetchFavoriteCoin?() ?? []
    }
    
    private func adjustScopeTitle(scope: String) -> String {
        scope == allTitle ? "" : scope
    }
    
    func didfavoriteButtonAction(cell: SearchCoinCell) {
        guard let indexPath = coinListTableView.indexPath(for: cell) else {
            return
        }
        searchCoinDataSource.selectModel(index: indexPath.row) { [weak self] uuid in
            self?.updateFavoriteHandler?(uuid)
        }
        DispatchQueue.main.async { [weak self] in
            self?.searchCoinDataSource.updateState(from: [indexPath.row])
            self?.coinListTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    deinit {
        print(#function)
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch searchStyle {
        case .favorite:
            break
        case .notification:
            searchCoinDataSource.selectModel(index: indexPath.row) { [weak self] uuid in
                self?.coordinator?.showNotificationInputViewController(uuid: uuid)
            }
        }
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
