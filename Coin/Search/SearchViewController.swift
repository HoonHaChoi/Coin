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
    
    // dummy uuids
    var uuids = ["5036ced7-890a-4b0b-8b63-f76777d2f8b3", // BTC upbit
                 "6b753a88-54c1-4be2-9c54-2c3f42ec17de", // BTC coinone
                "4de60a4e-213f-421b-8eb5-aa78159c1736", // EOS coinone
                "74ed03fc-240a-4a94-aff1-769b81cc9d16"] // ETC UPbit
    
    lazy var updateSearchResult: (([Coin]) -> ()) = { coinList in
        let findIndex = self.searchCoinDataSource.findIndexes(metaList: self.uuids)
        let indexPaths = self.searchCoinDataSource.makeIndexPath(indexes: findIndex)
        self.searchCoinDataSource.updateDataSource(from: coinList)
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
}

// coreData 연결 되면 살릴 예정
extension SearchViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        searchCoinDataSource.updateState(from: indexPath.row) { uuid in
//            uuids.append(uuid)
//        }
//        tableView.reloadRows(at: [indexPath], with: .none)
//        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
//        print(uuids)
//    }
//
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        searchCoinDataSource.updateState(from: indexPath.row) { uuid in
//            if let index = uuids.firstIndex(of: uuid) {
//                uuids.remove(at: index)
//            }
//        }
//        tableView.reloadRows(at: [indexPath], with: .none)
//        tableView.deselectRow(at: indexPath, animated: true)
//        print(uuids)
//        }
}

