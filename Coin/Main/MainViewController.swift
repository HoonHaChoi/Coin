import UIKit

class MainViewController: UIViewController, Storyboarded {
    
    typealias cryptoDataSource = TableDataSource<CryptoCell, Coin>
    private let mainDataSource: cryptoDataSource
    
    init(dataSource: cryptoDataSource) {
        self.mainDataSource = dataSource
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
    var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cryptoView.cryptoTableView.dataSource = mainDataSource
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
    
    private func requestCoins() {
        fetchCoinsHandler?()
    }
    
    lazy var showError: (NetworkError) -> () = { [weak self] error in
        let alert = UIAlertController(title: "에러", message: error.description)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    lazy var updateCoinList: ([Coin]) -> () = { [weak self] coins in
        self?.mainDataSource.updateDataSource(from: coins)
        DispatchQueue.main.async {
            self?.cryptoView.cryptoTableView.reloadData()
        }
    }
}
