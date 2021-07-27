import UIKit

class MainViewController: UIViewController, Storyboarded {
    
    private let mainDataSource: MainDataSourece
    
    init?(coder: NSCoder,
          dataSource: MainDataSourece) {
        self.mainDataSource = dataSource
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var tableView: UITableView!
    var fetchCoinsHandler: (() -> Void)?
    var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = mainDataSource
        tableView.register(cell: SearchCoinCell.self)
        requestCoins()
    }
    
    private func requestCoins() {
        fetchCoinsHandler?()
    }
    
    @IBAction func moveSearchViewController(_ sender: Any) {
        coordinator?.showSearchViewController()
    }
    
    lazy var showError: (NetworkError) -> () = { [weak self] error in
        DispatchQueue.main.async {
            print(error)
        }
    }
    
    lazy var updateCoinList: ([Coin]) -> () = { [weak self] coins in
        self?.mainDataSource.updateCoins(coins: coins)
        DispatchQueue.main.async {
            self?.tableView.reloadData()
        }
    }
}
