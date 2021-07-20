import UIKit
import Combine
import SocketIO
import SwiftyJSON

class ViewController: UIViewController, Storyboarded {
  
    let manager =  SocketManager(socketURL: URL(string: "http://34.64.77.122:8080/socket")!,
                                 config: [.log(false),
                                          .forceWebsockets(true),
                                          .path("/socket")])
    
    lazy var socket:SocketIOClient = manager.defaultSocket
    
    @IBOutlet weak var tableView: UITableView!
    
    private let imageLoader = ImageLoader()
    private var coins: [Coin] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(cell: SearchCoinCell.self)
        tableView.rowHeight = 80
        connectSocket()
    }
    
    var coordinator: MainCoordinator?
    
    @IBAction func moveSearchViewController(_ sender: Any) {
        coordinator?.showSearchViewController()
    }
    
    func connectSocket() {
        let decode = JSONDecoder()
        decode.keyDecodingStrategy = .convertFromSnakeCase
            
        socket.on("tickers") { data, ack in
            let data = try? JSON(data[0]).rawData()
            let codabledata = try? decode.decode([Coin].self, from: data ?? Data())
            self.coins = codabledata ?? []
        }
        
        socket.connect()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCoinCell.reuseIdentifier, for: indexPath) as? SearchCoinCell else {
            return .init()
        }
        cell.configure(coin: coins[indexPath.row], imageLoader: imageLoader)
        return cell
    }
}
