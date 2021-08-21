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
    
    private var segmentContainerView: SegmentContainerView = {
        let segmentContainerView = SegmentContainerView()
        segmentContainerView.translatesAutoresizingMaskIntoConstraints = false
        return segmentContainerView
    }()
    
    var fetchCoinsHandler: (() -> Void)?
    var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.dataSource = mainDataSource
        tableView.register(cell: SearchCoinCell.self)
        requestCoins()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureUI() {
        view.addSubview(segmentContainerView)
        
        NSLayoutConstraint.activate([
            segmentContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            segmentContainerView.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0),
            segmentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            segmentContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.55)
        ])
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
