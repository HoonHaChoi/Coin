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
    
    var fetchCoinsHandler: (() -> Void)?
    var requestLeaveEvent: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        cryptoView.cryptoTableView.dataSource = dataSource
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
        
        NSLayoutConstraint.activate([
            cryptoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cryptoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cryptoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cryptoView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
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
