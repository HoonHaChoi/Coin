import UIKit

class MainViewController: UIViewController, Storyboarded {
    
    typealias cryptoDataSource = TableDataSource<CryptoCell, Coin>
    private let dataSource: cryptoDataSource
    
    init(dataSource: cryptoDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cryptoView: CryptoView = {
        let view = CryptoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyView: EmptyView = {
        let empty = EmptyView(frame: .zero , title: "관심 있는 코인 목록이 비어 있습니다!",
                              description: "관심 있는 코인을 검색 또는 거래소를 \n 통해 추가 해주세요")
        empty.isHidden = true
        empty.translatesAutoresizingMaskIntoConstraints = false
        return empty
    }()
    
    var fetchCoinsHandler: (() -> Void)?
    var requestLeaveEvent: (() -> ())?
    var didCellTapped: ((Coin) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        cryptoView.cryptoTableView.dataSource = dataSource
        cryptoView.cryptoTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCoinsHandler?()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        requestLeaveEvent?()
    }
    
    private func configure() {
        view.addSubview(cryptoView)
        view.addSubview(emptyView)
        
        NSLayoutConstraint.activate([
            cryptoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cryptoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cryptoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cryptoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            
            emptyView.leadingAnchor.constraint(equalTo: cryptoView.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: cryptoView.trailingAnchor),
            emptyView.topAnchor.constraint(equalTo: cryptoView.topAnchor),
            emptyView.bottomAnchor.constraint(equalTo: cryptoView.bottomAnchor)
        ])
    }
    
    lazy var showError: (NetworkError) -> () = { [weak self] error in
        let alert = UIAlertController(title: "에러", message: error.description)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    lazy var updateCoinList: ([Coin]) -> () = { [weak self] coins in
        self?.dataSource.updateDataSource(from: coins)
        DispatchQueue.main.async {
            self?.cryptoView.cryptoTableView.reloadData()
            self?.isHiddienCryptoTableView()
        }
    }
    
    private func isHiddienCryptoTableView() {
        if dataSource.model.isEmpty {
            cryptoView.cryptoTableView.isHidden = true
            emptyView.isHidden = false
        } else {
            cryptoView.cryptoTableView.isHidden = false
            emptyView.isHidden = true
        }
    }
    
    func updateMeta(metaList: [CoinMeta]) {
        let findIndex = dataSource.findIndexes(uuids: metaList.map { $0.uuid })
        let changes = dataSource.compareMeta(indexes: findIndex, metaList: metaList)
        dataSource.updateModel(indexes: findIndex, metaList: metaList)
        let indexPath = dataSource.makeIndexPath(indexes: findIndex)
        
        DispatchQueue.main.async { [weak self] in
            self?.cryptoView.reloadRows(at: indexPath, to: changes)
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didCellTapped?(dataSource.model[indexPath.row])
    }
}
