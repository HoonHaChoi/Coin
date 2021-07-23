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
    
    private var imageLoader: ImageLoader
    private let mainDataSource: MainDataSourece
    
    init?(coder: NSCoder, imageLoader: ImageLoader, dataSource: MainDataSourece) {
        self.imageLoader = imageLoader
        self.mainDataSource = dataSource
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = mainDataSource
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
            self.mainDataSource.updateCoins(coins: codabledata ?? [])
        }
        
        socket.connect()
    }
}
